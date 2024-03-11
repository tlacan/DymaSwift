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



company.sortedEmployees.forEach({ print($0.uiText) })
/*
    On peut écrire également

    for employee in company.sortedEmployees {
        print($0.uiText)
    }
 */


let sortedSalaries =
    company.employees.compactMap({ $0.salary }) // permet d'avoir tous les salaires seulement en enlevant les valeurs nil
    .sorted() // tri de manière croissante
let smallestSalaryEmployee = company.employees.first(where: { $0.salary == sortedSalaries.first })
let biggestSalaryEmployee = company.employees.first(where: { $0.salary == sortedSalaries.last })

/*
 Si vous avez fait une fonction dans Company cela marche également
 voir biggestSmallestSalaryEmployee
 */


print("Plus petit salaire: \(smallestSalaryEmployee?.firstName ?? "") \(smallestSalaryEmployee?.lastName ?? "") \(smallestSalaryEmployee?.uiSalary ?? "")")
print("Plus grand salaire: \(biggestSalaryEmployee?.firstName ?? "") \(biggestSalaryEmployee?.lastName ?? "") \(biggestSalaryEmployee?.uiSalary ?? "")")


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

struct Company { // Pas besoin d'utiliser une Class pour company
    var employees: [Employee] = []
    /*
     Si vous avez fait un Set d'employees c'est bien (var employees: Set<Employee>)
     vous avez du rendre Employee conforme au protocole Hashable, voir Employee pour cela
     */

    var sortedEmployees: [Employee] { // si vous avez fait une fonction c'est pas un problème
        employees.sorted(by: { (employeeA, employeeB) in
            // j'ai fait une version courte, si vous avez comparé les prénoms puis les noms c'est bon aussi
            employeeA.uiText < employeeB.uiText
        })
    }

    func biggestSmallestSalaryEmployee(big: Bool = true) -> Employee? {
        var result: Employee?
        for employee in employees {
            if let currentResult = result {
                if (big && (employee.salary ?? 0) > (currentResult.salary ?? 0)) ||
                    (!big && (employee.salary ?? 0) < (currentResult.salary ?? 0)) {
                    result = employee
                }
            } else {
                result = employee
            }
        }
        return result
    }
}

class Employee: Hashable {
    let firstName: String
    let lastName: String
    var age: Int  // Si on veut optimiser on peut utiliser un UInt8
    var salary: Double? // Pensez à bien mettre le salaire comme optionnel
    var jobTitle: String = "Employee" // Si vous avez fait un enum pour JobTitle c'est bien aussi

    init(firstName: String, lastName: String, age: Int, salary: Double? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.salary = salary
    }

    var uiSalary: String? {
        guard let salary else { return nil }

        /*
         Si on voudrait afficher le salaire de manière "propre",
         il faudrait utiliser un nombre formatter
         */
        return String(format: "%.2f", salary) // Si vous avez afficher toutes les décimales, ce n'est pas grave
    }

    var uiText: String {
        "\(firstName) \(lastName) \(AgeCategory.value(from: age).uiName) \(jobTitle)"
    }

    // Si Employee est conforme à Hashable vous avez eu besoin de ces 2 fonctions

    // cette fonction permet de comparer 2 instances en surcharchant l'opérateur d'égalité ==
    static func == (lhs: Employee, rhs: Employee) -> Bool {
        lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName && lhs.age == rhs.age
    }

    // Hash permet de créer un identifiant unique pour différencier les objects
    // ici on peut combiner les propriété firstName, lastName et age
    func hash(into hasher: inout Hasher) {
        hasher.combine(firstName)
        hasher.combine(lastName)
        hasher.combine(age)
    }
}

class Manager: Employee {
    override init(firstName: String, lastName: String, age: Int, salary: Double? = nil) {
        super.init(firstName: firstName, lastName: lastName, age: age, salary: salary)
        self.jobTitle = "Manager"
    }
}
