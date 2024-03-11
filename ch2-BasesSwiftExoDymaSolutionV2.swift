import Foundation

/*
 Vous devez créer les structures nécessaires afin que le code suivant fonctionne.
 De plus, Vous devez gérer les catégories d'âge suivante: -25 ans, 25-35 ans, 36-50ans, 50ans+

 Enfin vous devez afficher dans la console les informations suivantes:
    1) Afficher la liste des noms des employés par ordre alphabétique (prénom / nom) avec leur catégorie d'âge
       et si ils sont Employés ou Manager.
    2) Afficher le nom/prénom/salaire de la personne avec le plus grand salaire connu.
    3) Afficher le nom/prénom/salaire de la personne avec le plus petit salaire connu.

   En V1
        Vous devez faire une solution qui utilise de l'héritage
   En V2 bonus
        Vous devez faire une solution sans héritage avec des Protocols

 PS pour afficher le salaire vous pouvez utiliser String(format: "%.2f", salary) dispo dans la librarie Foundation
   PS2 pour la V2 employees sera de type [EmployeeProtocol]

 */

 var company = Company()
 company.employees = [
        Employee(firstName: "John", lastName: "Doe", age: 43, salary: 2424.50),
        Employee(firstName: "Alice", lastName: "Wilson", age: 23, salary: 2634.00),
        Manager(firstName: "Francis", lastName: "Pichat", age: 51, salary: 4424.50),
        Manager(firstName: "Marie", lastName: "Dupont", age: 43, salary: 4200.58),
        Employee(firstName: "Bob", lastName: "Moragne", age: 34),
        Employee(firstName: "Kévin", lastName: "Drujon", age: 22, salary: 1424.50)
 ]

company.sortedEmployees.forEach({ print($0.uiText()) })
/*
    On peut écrire également

    for employee in company.sortedEmployees {
        print($0.uiText)
    }
 */


let sortedSalaries =
    company.employees.compactMap({ $0.salaryValue() }) // permet d'avoir tous les salaires seulement en enlevant les valeurs nil
    .sorted() // tri de manière croissante
let smallestSalaryEmployee = company.employees.first(where: { $0.salaryValue() == sortedSalaries.first })
let biggestSalaryEmployee = company.employees.first(where: { $0.salaryValue() == sortedSalaries.last })

/*
 Si vous avez fait une fonction dans Company cela marche également
 voir biggestSmallestSalaryEmployee
 */

print("Plus petit salaire: \(smallestSalaryEmployee?.uiSalaryText() ?? "")")
print("Plus grand salaire: \(biggestSalaryEmployee?.uiSalaryText() ?? "")")


enum AgeCategory {
    case under25
    case between25_35
    case between36_50
    case moreThan50

    var uiName: String {
        switch self {
        case .under25: return "-25 ans"
        case .between25_35: return "25-35 ans"
        case .between36_50: return "36-50 ans"
        case .moreThan50: return "+50 ans"
        }
    }

    static func value(from age: Int) -> AgeCategory {
        if age < 25 {
            return .under25
        }
        if age < 36 {
            return .between25_35
        }
        if age < 50 {
            return .between36_50
        }
        return .moreThan50
    }
}

enum EmployeeCategory: String {
    case Employee
    case Manager
}

struct Company {
    var employees: [EmployeeProtocol] = []

    var sortedEmployees: [EmployeeProtocol] { // si vous avez fait une fonction c'est pas un problème
        employees.sorted(by: { (employeeA, employeeB) in
            // j'ai fait une version courte, si vous avez comparé les prénoms puis les noms c'est bon aussi
            employeeA.uiText() < employeeB.uiText()
        })
    }

    func biggestSmallestSalaryEmployee(big: Bool = true) -> EmployeeProtocol? {
        var result: EmployeeProtocol?
        for employee in employees {
            if let currentResult = result {
                if (big && (employee.salaryValue() ?? 0) > (currentResult.salaryValue() ?? 0)) ||
                    (!big && (employee.salaryValue() ?? 0) < (currentResult.salaryValue() ?? 0)) {
                    result = employee
                }
            } else {
                result = employee
            }
        }
        return result
    }
}

protocol EmployeeProtocol {
    func uiText() -> String
    func salaryValue() -> Double?
    func uiSalaryText() -> String
}

struct Employee: EmployeeProtocol {
    let firstName: String
    let lastName: String
    var age: Int  // Si on veut optimiser on peut utiliser un UInt8
    var salary: Double? // Pensez à bien mettre le salaire comme optionnel
    let category = EmployeeCategory.Employee

    init(firstName: String, lastName: String, age: Int, salary: Double? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.salary = salary
    }

    func salaryValue() -> Double? {
        salary
    }

    func uiSalaryText() -> String {
        if let salary {
            return "\(firstName) \(lastName) \(String(format: "%.2f", salary))"
        }
        return "\(firstName) \(lastName)"
    }

    func uiText() -> String {
        "\(firstName) \(lastName) \(AgeCategory.value(from: age).uiName) \(category)"
    }

}


struct Manager: EmployeeProtocol {
    let firstName: String
    let lastName: String
    var age: Int  // Si on veut optimiser on peut utiliser un UInt8
    var salary: Double? // Pensez à bien mettre le salaire comme optionnel
    let category = EmployeeCategory.Manager

    init(firstName: String, lastName: String, age: Int, salary: Double? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.salary = salary
    }

    func salaryValue() -> Double? {
        salary
    }

    func uiSalaryText() -> String {
        if let salary {
            return "\(firstName) \(lastName) \(String(format: "%.2f", salary))"
        }
        return "\(firstName) \(lastName)"
    }

    func uiText() -> String {
        "\(firstName) \(lastName) \(AgeCategory.value(from: age).uiName) \(category)"
    }
}

