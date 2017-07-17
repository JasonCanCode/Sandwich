//: [⬅️](@previous)
/*:
 Very Scientific
 =====

 ![scientific_method](scientific_method.png)
 ...and Communicate
 -------------
 */

let steps: [ScientificMethodStep] = [
    .Purpose,
    .Research,
    .Hypothesis,
    .Experiment,
    .Analysis,
    .Conclusion,
    .Communicate
]

print("When Developing an App")
print("=======================")

for step in steps {
    let stepName = step.rawValue
    let stepInAppDev = step.whenDevelopingAnApp

    print(stepName, "-->", stepInAppDev)
}


//: [➡️](@next)

