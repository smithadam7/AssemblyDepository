//Adam Smith
//Implementation File for VehicleGarage_Search.cpp

#include <iostream>
#include <string>
#include "VehicleGarage_Search.h"
#include <algorithm>

namespace csci2312

{
	// Default constructor
	Vehicle_T::Vehicle_T() { };

	// Contructor to sets name and tag
	Vehicle_T::Vehicle_T(string v_name, string v_tag) {
		//  license is a unique vehicle identifier 
		license = v_tag;
		name = v_name;			
	};	
		
	// Destructor
	Vehicle_T::~Vehicle_T() {};
	
	void Vehicle_T::setName(string v_name) {
		name = v_name;
	}
		
	string Vehicle_T::getName() const {
		return name;
	}
		
	void Vehicle_T::setLicense(string v_tag) {
		license = v_tag;
	}
	string Vehicle_T::getLicense() const {
		return license;
	}

	Vehicle_T Vehicle_T::getType()
	{
		return Vehicle_T();
	}

	

	void Vehicle_T::whoAmI() const {};

	istream& operator >>(istream& ins, Vehicle_T& the_object)
		//Overloads the >> operator for input values of type Vehicle_T.
		//Precondition: If ins is a file input stream, then ins has already been
		//connected to a file.
	{		 
		ins >> the_object.name >> the_object.license;
		return ins;		
	};

	ostream& operator <<(ostream& outs, const Vehicle_T& the_object)
	//Overloads the << operator for output values of type Vehicle_T.
	//Precondition: If outs is a file output stream, then outs has already been
	//connected to a file.
	{		
		the_object.whoAmI();
		outs << endl;
	    return outs;		
	}

	void Garage_T::operator=(const Garage_T & source)
	{
		//cout << source.vehicles[0]->getName();
		//Clears vector to make ready for new items
		vehicles.clear();
		for (int i = 0; i < source.vehicles.size(); i++) {
			vehicles.push_back(source.vehicles[i]);
		}
	}

	// A sort predicate as a member function, same logic as in non-member
	bool Garage_T::sortVehiclePredicate_member(VehiclePtr p1, VehiclePtr p2) {
		return(p1->getLicense() < p2->getLicense());
	}
		
	// Needed for STL "sort" algorithm
	bool sortVehiclePredicate(VehiclePtr p1, VehiclePtr p2) {
		return(p1->getLicense() < p2->getLicense());
	}

	// Needed for STL "search" algorithm
	bool searchVehiclePredicate(VehiclePtr p1, VehiclePtr p2) {
		// to be finished, if the search generic algorithm is used
		return true; 
	}
	
	bool operator ==(Vehicle_T p1, Vehicle_T p2) {
		return(p1.getLicense() == p2.getLicense());
	}

	///////////////////////////  Car_T Implementation
	// Default
	Car_T::Car_T() {};

	// Car_T implementation
	Car_T::Car_T(string v_name, string v_tag) : Vehicle_T(v_name, v_tag) {};
	
	void Car_T::whoAmI() const {
		cout  << name << " car, License: " << license << endl;
	}

	// zoom!
	void Car_T::zoom() {
		cout << "Zoom!" << endl;
	}

	///////////////// Truck_T implementation
	// Default
	Truck_T::Truck_T() {};

	Truck_T::Truck_T(string v_name, string v_tag) : Vehicle_T(v_name, v_tag) { };

	void Truck_T::whoAmI() const {
		
		cout << name << " truck, License: " << license  << endl;
	}

	void Truck_T::Vroom() {
		cout << "Vroom!" << endl;
	}
	
	///////////// Garage Implementation

	// Garage exceptions
	Garage_E::Garage_E(string p_error_message) {
		errorMessage = p_error_message;
	};
	void Garage_E::handleError() {
		cout << errorMessage << endl;
		//  Other processing, maybe logging etc.
	};

	// Contructor to set size
	Garage_T::Garage_T(unsigned p_capacity) {
		vehicles.reserve(p_capacity);
	};

	// Copy constructor: creates new object as a copy p_bag.  Objects make noise when copied
	Garage_T::Garage_T(const Garage_T& p_bag) {

		vehicles.reserve(p_bag.getCapacity());		

		for (unsigned i = 0; i < p_bag.getSize(); i++) {
						
			Car_T* carPointer = NULL;
			Truck_T* truckPointer = NULL;

			// To find which derived type of object needs to be copied
			// Runtime Type Identification (RTTI)
			carPointer = dynamic_cast<Car_T*>(p_bag.vehicles[i]);
			truckPointer = dynamic_cast<Truck_T*>(p_bag.vehicles[i]);

			if (carPointer != NULL)
			{				
				vehicles.push_back(new Car_T(*carPointer));
				carPointer->zoom();
			}
			else 
			if (truckPointer != NULL)
			{				
				vehicles.push_back(new Truck_T(*truckPointer));
				truckPointer->Vroom();
			}
		}
	}

	// Destructor
	Garage_T::~Garage_T() {
		for(unsigned int i = 0; i < vehicles.size(); i++) {
			delete vehicles[i];
		}
	};

	size_t Garage_T::getCapacity() const {
		return vehicles.capacity();
	}

	size_t Garage_T::getSize() const {
		return vehicles.size();
	}	

	// Adds vehicle to Bag
	void Garage_T::addVehicle(VehiclePtr p_vehicle) throw (Garage_E) {

		if (vehicles.size() < vehicles.capacity())
			vehicles.push_back(p_vehicle);
		else				
			throw(Garage_E("Garage is full"));
	}

	// Sort Garage.  
	// Uses STL "sort", containter's iterator, and a predicate function to compare elements
	void Garage_T::sortVehicles() {
		// How to pass in a sort predicate, a non-member.  It is a function pointer that is being passed
		sort(vehicles.begin(), vehicles.end(), sortVehiclePredicate);
		// How to pass in a sort predicate, a static member.  It needs an & to become an address of the method
		sort(vehicles.begin(), vehicles.end(), &sortVehiclePredicate_member);
		cout << "Vehicles have been sorted.\n";
	}
		
	void Garage_T::findAndReleaseVehicle() {

		VehiclePtr whatVehicle = new Vehicle_T;
		cin >> *whatVehicle;

		// Manual find - replace with generic algorithm "search"
		for (where = vehicles.begin(); where != vehicles.end(); where++) {
			            
			// Check if equal using == operator on Vehicle_T
			if ((**where) == (*whatVehicle))
				break;
		}
		//  Invoke "search"
		//  ...
	
		// Found it, so now release
		if (where != vehicles.end())
			vehicles.erase(where);
		else
			cout << "Vehicle not found! \n";
	}
	
	
	// Release Cars
	void Garage_T::releaseCars() {
		Car_T* carPointer = NULL;
		for (unsigned i = 0; i < vehicles.size(); i++)
		{			
			// To find whether basePointer is pointing to which Derived type of object
			// Runtime Type Identification (RTTI)
			carPointer = dynamic_cast<Car_T*>(vehicles[i]);
			if (carPointer != NULL)  // It is a Car!
			{
				carPointer->zoom();
				delete vehicles[i];
				vehicles.erase(vehicles.begin() + i);
				i--;
			}
		}
	}

	// Release Trucks
	void Garage_T::releaseTrucks() {
		Truck_T* truckPointer = NULL;
		for (unsigned i = 0; i < vehicles.size(); i++)
		{
			// To find whether basePointer is pointing to which Derived type of object
			// Runtime Type Identification (RTTI)
			truckPointer = dynamic_cast<Truck_T*>(vehicles[i]);
			if (truckPointer != NULL)  // It is a truck
			{
				truckPointer->Vroom();
				delete vehicles[i];//deletes trucks
				vehicles.erase(vehicles.begin() + i);
				i--;
			}
		}
	}
		
	ostream& operator <<(ostream& outs, const Garage_T& the_object)
		//Overloads the << operator for output values of type Garage_T.
		//Precondition: If outs is a file output stream, then outs has already been
		//connected to a file.
	{
		if (the_object.vehicles.size() == 0)
			outs << "The garage is empty" << endl;

		for (unsigned i = 0; i < the_object.vehicles.size(); i++) {
			outs << *(the_object.vehicles[i]);
		};
		
		return outs;
	}

} // namespace csci2312