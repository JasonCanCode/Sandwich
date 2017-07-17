import Foundation

public var skillsNeededToMakeAGoodApp: [String] {
    return [
        "* Inventive",
        "* Inquisitive",
        "* Thoughtful",
        "* Creative",
        "* Logical",
        "* Meticulous",
        "* Impartial",
        "* Social",
        "* Organized",
        "* Personable"
    ]
}

public enum ScientificMethodStep: String {
    case Purpose
    case Research
    case Hypothesis
    case Experiment
    case Analysis
    case Conclusion
    case Communicate

    public var whenDevelopingAnApp: String {
        switch self {
        case .Purpose:
            return "Come up with an idea for an app that people would want"
        case .Research:
            return "Find out if the idea is unique and desirable"
        case .Hypothesis:
            return "Decide how the app should work and what it should look like"
        case .Experiment:
            return "Write the code to make the app work as intended"
        case .Analysis:
            return "Make sure the app is ACTUALLY working as intedned"
        case .Conclusion:
            return "Find out if people like the app"
        case .Communicate:
            return "Tell everyone to get your app"
        }
    }

    public var teamMember: TeamMember {
        switch self {
        case .Purpose:
            return .Client
        case .Research:
            return .Business_Analyst
        case .Hypothesis:
            return .Designer
        case .Experiment:
            return .Software_Engineer
        case .Analysis:
            return .Quality_Assurance
        case .Conclusion:
            return .Usability_Tester
        case .Communicate:
            return .Marketer
        }
    }
}

public enum TeamMember: String {
    case Client
    case Business_Analyst
    case Designer
    case Software_Engineer
    case Quality_Assurance
    case Usability_Tester
    case Marketer
    case UX_Architect
    case Account_Manager
    case Project_Manager

    public var keySkill: String {
        switch self {
        case .Client:
            return "Inventive"
        case .Business_Analyst:
            return "Inquisitive"
        case .Designer:
            return "Creative"
        case .Software_Engineer:
            return "Logical"
        case .Quality_Assurance:
            return "Meticulous"
        case .Usability_Tester:
            return "Impartial"
        case .Marketer:
            return "Social"
        case .UX_Architect:
            return "Thoughtful"
        case .Account_Manager:
            return "Personable"
        case .Project_Manager:
            return "Organized"
        }
    }

    public var contribution: String {
        switch self {
        case .Client:
            return ScientificMethodStep.Purpose.whenDevelopingAnApp
        case .Business_Analyst:
            return ScientificMethodStep.Research.whenDevelopingAnApp
        case .Designer:
            return ScientificMethodStep.Hypothesis.whenDevelopingAnApp
        case .Software_Engineer:
            return ScientificMethodStep.Experiment.whenDevelopingAnApp
        case .Quality_Assurance:
            return ScientificMethodStep.Analysis.whenDevelopingAnApp
        case .Usability_Tester:
            return ScientificMethodStep.Conclusion.whenDevelopingAnApp
        case .Marketer:
            return ScientificMethodStep.Communicate.whenDevelopingAnApp
        case .UX_Architect:
            return ScientificMethodStep.Hypothesis.whenDevelopingAnApp
        case .Account_Manager:
            return "Make sure the Client is getting what they need"
        case .Project_Manager:
            return "Keep the team in track"
        }
    }

    public func printInfo() {
        print(self.rawValue)
        print("-----------------")
        print("Key Skill:", keySkill)
        print("Contribution:", contribution)
    }

    public static func printWhoWeForgot() {
        let whoWeForgot: [TeamMember] = [
            .UX_Architect,
            .Account_Manager,
            .Project_Manager
        ]

        for member in whoWeForgot {
            member.printInfo()
            print("\n")
        }
    }
}
