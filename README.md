
# PID Runner

This is a demo project showing how concept of `PID Controller` used by `Pulse` framework can tranform data from sensors to interact with application.
Use `force touch` by pressing on the screen or `slider` to check average speed at given time of running training.

# Setting up

Install `Pods` dependencies:

```swift
    pod install
```

Project uses `MapBox`, so you have to start from adding `MapBoxToken` file with your token to root folder of the project.
Make sure it has right permissions:

```swift
    sudo chmod 755 MapBoxToken 
```

Using `force touch` is possible only when deployed on real device.

# Licence
Repository is released under the MIT License.
