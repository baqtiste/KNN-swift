//: Playground - noun: a place where people can play

import Foundation

/*
 ## K Neirest Neighbors
 This playground trains the KNN classifier with a CSV file and predict with values given.
 
 - Note:
 When using KNN you have to have continuous features (Double).
 For this example we are going to use a famous dataset with different types of iris.
 */

enum IrisSpecies: String {
  case setosa, versicolor, virginica
  
  static func fromString(_ s: String) -> Int {
    switch s {
    case IrisSpecies.setosa.rawValue: return 0
    case IrisSpecies.versicolor.rawValue: return 1
    case IrisSpecies.virginica.rawValue: return 2
    default: return 0
    }
  }
  
  static func fromLabel(_ l: Int) -> String {
    switch l {
    case 0: return IrisSpecies.setosa.rawValue
    case 1: return IrisSpecies.versicolor.rawValue
    case 2: return IrisSpecies.virginica.rawValue
    default: return IrisSpecies.setosa.rawValue
    }
  }
}

/*
 Open the CSV file
 */
guard let irisCSV = Bundle.main.path(forResource: "Iris", ofType: "csv") else {
  print("Resource could not be found!")
  exit(0)
}

/*
 Read the CSV file
 */
guard let csv = try? String(contentsOfFile: irisCSV) else {
  print("File could not be read!")
  exit(0)
}

/*
 ## Parse the CSV
 split the lines with the character `\n` and create an array
 */
let rows = csv.characters.split(separator: "\n").map { String($0) }

/*
 split values in row with the character `,` and create an array
 */
let irisData = rows.map { row -> [String] in
  let split = row.characters.split(separator: ",")
  return split.map { String($0) }
}

/*
 Extract the labels (the iris species)
 */
let rowOfClasses = 4
let labels = irisData.map { row -> Int in
  let label = IrisSpecies.fromString(row[rowOfClasses])
  row.dropLast()
  return label
}

/*
 Extract the data
 col 1: sepal length
 col 2: sepal width
 col 3: petal length
 col 4: petal width
 */
let data = irisData.map { row in
  return row.enumerated().filter { $0.offset != rowOfClasses }.map { Double($0.element)! }
}

/*
 Initialize the classifier with our data and labels
 */
let knn = KNeirestNeighborsClassifier(data: data, labels: labels, nNeighbors: 10)

/*
 Predict the label for the values given
 */
let predictionLabels = knn.predict([[5.7, 3.8, 1.7, 0.3]])
let predictionIrisType = predictionLabels.map({ IrisSpecies.fromLabel($0) })

print(predictionIrisType)
