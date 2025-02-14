---
name: 🐞 Bug Report | Bug 提交  
description: Please describe the bug you found. | 请描述您在使用过程中遇到的问题。  
title: "🐞 [Bug] <your title xxx>"  
labels: ["bug"]
---

body:
- type: markdown
  attributes:
    value: "Please fill out the info before you submit a bug. | 请在您提交 bug 之前，回答以下这些问题。"

- type: textarea
  attributes:
    label: Version
    description: What is the version of your agentUniverse? | 您使用的agentUniverse版本是多少？
    placeholder: "Example: version 0.0.13"
  validations:
    required: true

- type: textarea
  attributes:
    label: System
    description: What is your system environment? | 您的系统版本是什么？ [Linux/Mac/Windows]
    placeholder: "Example: Ubuntu 20.04"
  validations:
    required: true

- type: textarea
  attributes:
    label: Actions
    description: What did you do? | 您做了什么操作？
    placeholder: "Describe the actions you took"
  validations:
    required: false

- type: textarea
  attributes:
    label: Problem
    description: What kind of problem are you having? | 您遇到了什么问题？
    placeholder: "Describe the problem"
  validations:
    required: false

- type: textarea
  attributes:
    label: Expected
    description: What is your expected outcome? | 您期望的结果是怎样的？
    placeholder: "Describe the expected results"
  validations:
    required: false

- type: textarea
  attributes:
    label: reproduce
    description: Steps to reproduce the bug | bug复现步骤
    placeholder: "Step 1: ..., Step 2: ..."
  validations:
    required: false
