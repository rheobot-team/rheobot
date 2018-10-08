# hubot-maven-search

A hubot script that searches in maven central repository

See [`src/maven-search.coffee`](src/maven-search.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-maven-search --save`

Then add **hubot-maven-search** to your `external-scripts.json`:

```json
[
  "hubot-maven-search"
]
```

## Sample Interaction

```
user1>> @hubot maven spring-boot
hubot>> @user1
org.springframework.boot:spring-boot:10.1.42
org.apache.camel:spring-boot:1.1.1
org.activiti:spring-boot:0.0.0
...

user1>> @hubot maven junit
hubot>> @user1
junit:junit:10.1.42

user1>> @hubot maven org.springframework.boot:spring-boot
hubot>> @user1
org.springframework.boot:spring-boot:10.1.42

user1>> @hubot maven junit:junit
hubot>> @user1
junit:junit:10.1.42
```

## NPM Module

https://www.npmjs.com/package/hubot-maven-search
