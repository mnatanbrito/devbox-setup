#!/bin/zsh

#######################
# JSON Merge Helpers
#######################

function validate_json() {
    local file="$1"
    if [ ! -f "$file" ]; then
        return 1
    fi
    jq empty "$file" 2>/dev/null
    return $?
}

function deep_merge_json() {
    local source_file="$1"
    local target_file="$2"

    # If source doesn't exist, nothing to do
    if [ ! -f "$source_file" ]; then
        echo "${YELLOW}Source file $source_file does not exist, skipping${NOCOLOR}"
        return 0
    fi

    # Validate source JSON
    if ! validate_json "$source_file"; then
        echo "${RED}Invalid JSON in source file: $source_file${NOCOLOR}"
        return 1
    fi

    # If target doesn't exist, just copy source
    if [ ! -f "$target_file" ]; then
        echo "${BLUE}Target $target_file doesn't exist, copying from source${NOCOLOR}"
        mkdir -p "$(dirname "$target_file")"
        cp "$source_file" "$target_file"
        return 0
    fi

    # Validate target JSON
    if ! validate_json "$target_file"; then
        echo "${RED}Invalid JSON in target file: $target_file${NOCOLOR}"
        return 1
    fi

    echo "${BLUE}Merging $source_file into $target_file${NOCOLOR}"

    # Deep merge: target values preserved, source adds new keys
    # Objects: recursively merge
    # Arrays: concatenate and deduplicate
    # Scalars: target value wins
    local merged
    merged=$(jq -s '
      def deep_merge:
        if type == "array" then
          . as $arr | $arr[0] as $a | $arr[1] as $b |
          if ($a | type) == "object" and ($b | type) == "object" then
            $a | to_entries | map(.key) | . as $akeys |
            $b | to_entries | map(.key) | . as $bkeys |
            ($akeys + $bkeys) | unique | map(. as $k |
              {($k): ([$a[$k], $b[$k]] | deep_merge)}
            ) | add
          elif ($a | type) == "array" and ($b | type) == "array" then
            ($a + $b) | unique
          else
            $a // $b
          end
        else .
        end;
      [.[0], .[1]] | deep_merge
    ' "$target_file" "$source_file")

    if [ $? -ne 0 ]; then
        echo "${RED}Failed to merge JSON files${NOCOLOR}"
        return 1
    fi

    # Write merged content back to target
    echo "$merged" > "$target_file"
    echo "${GREEN}Successfully merged into $target_file${NOCOLOR} ✅"
    return 0
}
