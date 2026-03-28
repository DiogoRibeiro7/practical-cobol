# GitHub commands

Create the repository from inside the project folder:

```bash
gh repo create practical-cobol \
  --public \
  --source=. \
  --remote=origin \
  --push \
  --description "Hands-on COBOL lessons, exercises, and mini projects for learning practical business-oriented COBOL."
```

Add topics:

```bash
gh repo edit --add-topic cobol,legacy-systems,education,tutorials,enterprise-software,file-processing,programming-language
```
