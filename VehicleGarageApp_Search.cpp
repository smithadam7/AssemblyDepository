// Adam Smith
// May 2 2017
// Compiled and ran successfully on Visual Studio


// ***************************************************************************************
//  This program models a garage with vehicles to demonstrate polymorphism
//  It holds a vector of pointers to a generic Vehicle, but specific vehicles are added 
//  STL vector container is used, and also a vector's iterator
//  Template method is used to release specific types of Vehicles
//  Generic algorithm "sort" is used.  It demonstrates use of iterators and a Ordering predicate
//  Generic algorithm "search" needs to be written.  It demonstrates use of iterators and an Equality predicate
// ***************************************************************************************


#include <iostream>
#include <cstdlib>
#include <string>
#include <fstream>
#include <algorithm>
#include "VehicleGarage_Search.h"

using namespace csci2312;
using namespace std;

// ======================
//     main function
// ======================
int main()
{
	//  Instantiate the container with given capacity
	Garage_T garage(10);

	//  Generic pointer used to add items
	VehiclePtr newVehicle;

	string vehicle_name;
	int choice = -1;

	//garage.addVehicle(new Car_T("Toyota", "123"));

	//Read Inventory From File
	string tempName, tempLicense, vehicleType;
	ifstream infile;
	try {
		infile.open("inventory.txt");
		if (infile.fail()) {
			throw FileIOException();//if the file can't be read
		}
	}
	catch (FileIOException) {
		cout << "Error: File could not be read.\n";
		return 0;
	}
	//infile.open("inventory.txt");
	while (!infile.eof()) {
		infile >> tempName;
		infile >> tempLicense;
		infile >> vehicleType;
		if(vehicleType == "car")
			garage.addVehicle(new Car_T(tempName, tempLicense));
		if(vehicleType == "truck")
			garage.addVehicle(new Truck_T(tempName, tempLicense));
	}
	infile.close();
	// Main Menu
	while (choice != 0)  // not a bullet proof data entry, enhancements welcome
	{
		cout << endl;		
		cout << "MAIN MENU" << endl;
		cout << "0) Quit" << endl;
		cout << "1) Add Car" << endl;
		cout << "2) Add Truck" << endl;
		cout << "3) Print Garage Content" << endl;
		cout << "4) Release All Cars" << endl;
		cout << "5) Release All Trucks" << endl;
		cout << "6) Sort Vehicles" << endl;
		cout << "7) Find and Release a Vehicle" << endl;

		cin >> choice;
		//Detecting User Input Error
		if (cin.fail()) {
			cin.clear();
			cin.ignore();
			cout << "Input Invalid\n";
		}

		switch (choice) { 			     

		case 1:  
			cout << "Enter Car's Name and License: ";
			// Uses input operator to read in info about a vehicle
			newVehicle = new Car_T;
			cin >> *newVehicle;
			try {
				garage.addVehicle(newVehicle); // Polymorphism: addVehicle is defined to add generic Vehicle_T, but passes in Car_T
			}
			catch (Garage_E e) {
				e.handleError();
			}
			break;
		case 2: 			
			// Uses input operator to read in info about a vehicle
			newVehicle = new Truck_T;
			cout << "Enter Truck's Name and License: ";
			cin >> *newVehicle;
			try {
				garage.addVehicle(newVehicle); // Polymorphism: addVehicle is defined to add generic Vehicle_T, but passes in Truck_T
			}
			catch (Garage_E e) {
				e.handleError();
			}
			break;
		case 3: 
			// Prints content of garage
			cout << garage;  
			break;
		case 4:
			//  Release all the Cars

			//  Dedicated method
			//bag.releaseCats();

			// FINAL PROJECT FEATURE - invoke function template
			// Template method
			 garage.releaseVehicles<Car_T>();
			 Car_T().zoom();

			break;
		case 5:
			//  Release all the Trucks

			//  Dedicated method			
			//garage.releaseTrucks();

			// FINAL PROJECT FEATURE - invoke function template
			// Template method 
			garage.releaseVehicles<Truck_T>();
			Truck_T().Vroom();

			break;
		case 6:
			// Sort the bag
			garage.sortVehicles();
			break;
		case 7:		
			//  Asks for a search target, finds and removes the item
			cout << "Enter Vehicle's Name and License: ";
			garage.findAndReleaseVehicle();
			break;
		default:
			break;
		};
		
	}

	// Copy constructor demo
	cout << "Copy Constructor Demo" << endl;
	Garage_T new_garage = Garage_T(garage);
	cout << new_garage;

	// Assignment demo
	cout << "Assignment Demo" << endl;
	Garage_T garage1 = Garage_T(2);
	garage1.addVehicle(new Car_T("Toyota", "123"));
	garage1.addVehicle(new Car_T("Jeep", "345"));
	cout << "Content of Garage1:" << endl;
	cout << garage1;

	Garage_T garage2 = Garage_T(3);
	garage2.addVehicle(new Truck_T("GMC", "560"));
	garage2.addVehicle(new Truck_T("Dodge", "555"));
	garage2.addVehicle(new Truck_T("Ranger", "783"));
	cout << "Content of Bag2:" << endl;
	cout << garage2;

	// assignemnt operator is overloaded! - EXTRA CREDIT
	//This works but seems to cause an issue upon exiting program
	// garage1 = garage2;
	// cout << "new contents of garage1\n";
	// cout << garage1;
	

	system("pause");

	return 0;
}

