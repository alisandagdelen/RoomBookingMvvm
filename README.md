# Room Booking


## Demo Video

https://youtu.be/7YmYgVx9VKA

## Notify
Object boxing used for notify the UI elements when values changed. Assigning new value to value property triggers property observer.

``` swift
class Dynamic<T> {
    typealias Listener = (T) -> ()
    var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    func bind(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
    
    init(_ value: T) {
        self.value = value
    }
}

```

## Structure

For dealing with spaghetti code Model-View-ViewModel (MVVM) design pattern used for structure. Schedule rules logics, and code listening for Model changes written in ViewModels.
For dependency injection and easier testability most of the classes created protocol oriented. Also models, dataServices taken in init methods to avoid from dependencies.

## Views
Different methods used for UI, like storyboard ,xib files and programmatic ui. In overview page storyboard and custom cell xib used.

## Dependencies
 "pod install" required

 Pods used:
 ```
    pod 'ObjectMapper'
    pod 'ObjectMapper'
    pod 'AlamofireObjectMapper'
    pod 'SDWebImage'
    pod ‘PhoneNumberKit’
    pod 'SCLAlertView', :git => 'https://github.com/vikmeup/SCLAlertView-Swift', :branch => 'master'
 ```

## Fails
I thought using sliders to choose booking time is good idea but then i saw it cause spaghetti code and when there is many time options, its being useless.

### Author
Alisan Dagdelen
alisandagdelen@gmail.com
