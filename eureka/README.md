# hubot-eureka

A hubot script to interact with Eureka

See [`src/eureka.coffee`](src/eureka.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-eureka --save`

Then add **hubot-eureka** to your `external-scripts.json`:

```json
[
  "hubot-eureka"
]
```

## Sample Interaction

```
user1>> @hubot eureka apps
hubot>> @user1
AppA
AppB
AppC
```

```
user1>> @hubot eureka apps AppB
hubot>> @user1
InstanceId001
InstanceId002
InstanceId003
```

```
user1>> @hubot eureka instances InstanceId001
hubot>> @user1
<details about instances with InstanceId001>
```

## NPM Module

https://www.npmjs.com/package/hubot-eureka
