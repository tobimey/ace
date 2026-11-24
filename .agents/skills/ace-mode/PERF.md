# Perf

Makes something that works but is too slow faster, with numbers before and after.

1. Measure it the way the user hits it, three runs or more. Write down the command, each number, and the spread. When it is not slow, report the numbers and stop.
2. Find what the time goes to, with a profiler or a timer around each step, and trace it to its source.
3. `ace-implement`, with the fix for that source as the plan. Behavior stays the same.
4. Measure again the same way. When the gain is inside the spread, revert the fix and stop. Report the numbers before and after, with the command.
5. Finish the change, as [BUILD.md](BUILD.md), section Finish a change, says.
