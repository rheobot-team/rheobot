# hubot-gradle-version

A hubot script that gets the current release version of Gradle

See [`src/gradle-version.coffee`](src/gradle-version.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-gradle-version --save`

Then add **hubot-gradle-version** to your `external-scripts.json`:

```json
[
  "hubot-gradle-version"
]
```

## Sample Interaction

```
user1>> @hubot gradle version
hubot>> @user1 10.1.42
```

## NPM Module

https://www.npmjs.com/package/hubot-gradle-version
