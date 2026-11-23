# Custom

A domain the project adds as `ace/checks/<name>.md`. This file says how to run its pass, and the project file says what to find.

## Before scanning

Read the project file in full. Do its Before scanning section when it has one.

## Find

What the Find section of the project file lists. What its Belongs elsewhere section names is out of scope.

## Drop

Apply the Drop section of the project file.

## Bar

Follow the Bar section of the project file when it has one. Otherwise: highest first, and file only Critical and High, rated by its Severity section. Ties go to the smaller safe fix.

## Ticket

Follow the Ticket section of the project file when it has one. Otherwise: Title starts with the check's name and `: `, such as `Accessibility: `. Type is `Chore`. Who this is from is the check's name plus Auditor, such as Accessibility Auditor.
