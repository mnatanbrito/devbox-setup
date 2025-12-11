# Report Work Command

This command generates a report of the work a user, specified by the GitHub handle, has done. A time range can be specified to filter the work time span.

## Instruction

To generate the report, use the `gh` command line to search for the commits of the user specified as a parameter. Use the title and description of the commits to generate an easy to understand message summarizing the work done.

## Format

The report should be follow the format:

<report_format>

- Dec

  - Dec 11

    - [Feature] Feature description
      - Pull request link

    - [Fix] Bug fix description
      - Pull request link
  - Dec 10

    - [Feature] Feature description
      - Pull request link

    - [Fix] Bug fix description
      - Pull request link

...

</report_format>

## Usage

The following are the expected usage cases for the command:

- `/report-work myusername`: Generates a report for user `myusername` for the past 2 weeks.
- `/report-work myusername "Nov 15"`: Generates a report for user `myusername` since `Nov 15`.
- `/report-work myusername "Nov 15" "Dec 5"`: Generates a report for user `myusername` from `Nov 15` to `Dec 5`.
