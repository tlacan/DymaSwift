
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

