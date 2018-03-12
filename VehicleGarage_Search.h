// Adam Smith
// Interface File for Vehicle Garage
#pragma once

#include <iostream>
#include <string>
#include <vector>
using namespace std;
//Error detection
class FileIOException
{
	//  Nothing inside, just a class type to handle exception
};

namespace csci2312
{
	using std::string;
	using std::ostream;
	using std::istream;
	using std::cout;
	using std::endl;
	using std::cin;
	using std::vector;

	// FINAL PROJECT FEATURE - class hierarchy
	// Base Class with all the listed components 
	class Vehicle_T
	{
	public:
		// Dafault Constructor		
		Vehicle_T();

		// Constructor sets Vehicle's name and license plate number
		Vehicle_T(string, string);		

		// Destructor
		~Vehicle_T();		
				
		// Accessors and Mutators
		void setName(string);
		string getName() const;

		void setLicense(string);
		string getLicense() const;

		Vehicle_T getType();

		// FINAL PROJECT FEATURE - virtual method
		// Vehicle introduces itself. A virtual method: the derived classes will redefine it
		void virtual whoAmI() const;
		
		// FINAL PROJECT FEATURE 
		// Overloads the >> operator for input values of type Vehicle_T	
		friend istream& operator >>(istream& ins, Vehicle_T& the_object);
			//Precondition: If ins is a file input stream, then ins has already been
			//connected to a file.

		// FINAL PROJECT FEATURE 
		// Overloads the << operator for output values of type Vehicle_T.
		friend ostream& operator <<(ostream& outs, const Vehicle_T& the_object);
			//Precondition: If outs is a file output stream, then outs has already been
			//connected to a file.		
	
	protected:
		// FINAL PROJECT FEATURE - unique attribute on a base class			
		// Uniquely identifies the elements in the container
		string license;

		string name;		
	};

	// FINAL PROJECT FEATURE - Pointer and type alias
	// Use 'typedef' to define a new type for the pointer to the base element
	typedef Vehicle_T* VehiclePtr;

	// FINAL PROJECT FEATURE - generic "sort" predicate for order
	// Function to support generic "sort"	
	// Returns true if vehicle pointed to by the first pointer is 'lesser' (whatever it means) 
	// than a vehicle pointed to by the second pointer 
	bool sortVehiclePredicate(VehiclePtr, VehiclePtr);

	// FINAL PROJECT FEATURE - generic "search" predicate for equality
	// Function to support generic "search"	
	// Returns true if vehicle pointed to by the first pointer is 'equal' (whatever it means) 
	// to a vehicle pointed to by the second pointer 
	bool searchVehiclePredicate(VehiclePtr, VehiclePtr);

	
	// FINAL PROJECT FEATURE
	// Two sub-classes

	class Car_T : public Vehicle_T {
		public:
			// Default
			Car_T();

			// Custom Constructor to set car name and license
			Car_T(string, string);
			
			// FINAL PROJECT FEATURE - virtual method redefined
			// Vehicle introduces itself: "My name is <name>.  I am a car."
			void virtual whoAmI() const override;

			// FINAL PROJECT FEATURE - unique to sub-class
			// zoom!
			void zoom();
	};

	class Truck_T : public Vehicle_T {
		public:
			// Default
			Truck_T();

			// Constructor sets Truck's name and liscense
			Truck_T(string, string);

			// FINAL PROJECT FEATURE - virtual method redefined
			// Vehicle introduces itself: "My name is <name>.  I am a truck."
			void virtual whoAmI() const override;

			// FINAL PROJECT FEATURE - unique on a sub-class
			// Vroom!
			void Vroom();
	};

	// FINAL PROJECT FEATURE - Exception
	class Garage_E {
	private:
		string errorMessage;
	public:
		//  Constructor set a message
		Garage_E(string); 
		void handleError();
	};

	// FINAL PROJECT FEATURE - Abstraction
	// Bag container abstraction.  Holds an STL container
	// All features are required

	class Garage_T {
	  public:
		  
		  // Default Contructor to sets Bag's capacity
		  Garage_T(unsigned=MAX_CAPACITY);

		  // FINAL PROJECT FEATURE - copy constructor
		  // Copy Constructor 
		  Garage_T(const Garage_T&);

		  // FINAL PROJECT FEATURE - destructor
		  // Destructor
		  ~Garage_T();

		  size_t getCapacity() const;
		  size_t getSize() const;

		  // FINAL PROJECT FEATURE - Polymorphism
		  // Adds a Vehicle to te garage, passsing the base pointer.  
		  void addVehicle(VehiclePtr) throw (Garage_E);

		  // FINAL PROJECT FEATURE - Generic Algorithm
		  // Sort Vehicles
		  void sortVehicles();

		  //static bool sortVehiclePredicate_member(VehiclePtr, VehiclePtr);

		  // FINAL PROJECT FEATURE - Generic Algorithm
		  // Find and Relese a vehicle
		  void findAndReleaseVehicle();
		  		  		  
		  // Release Cars
		  void releaseCars();

		  // Release Trucks
		  void releaseTrucks(); 	 
		  		  
		  // FINAL PROJECT FEATURE - Function Template
		  // Template function to release vehicles - replaces two above methods
		  // Invocation will plug in a specific vehicle type 		  
		  template<typename VehicleType_T> void releaseVehicles() {
			  // Identify a temnplate opportunity in your project, code goes here
			  VehicleType_T* vehiclePointer = NULL;
			  for (unsigned i = 0; i < vehicles.size(); i++)
			  {
				  // To find whether basePointer is pointing to which Derived type of object
				  // Runtime Type Identification (RTTI)
				  vehiclePointer = dynamic_cast<VehicleType_T*>(vehicles[i]);
				  if (vehiclePointer != NULL)  // It is a Vehicle
				  {
					  delete vehicles[i];
					  vehicles.erase(vehicles.begin() + i);
					  i--;
				  }
			  }
		  };

		  // FINAL PROJECT FEATURE
		  // Overloaded assignment operator - EXTRA CREDIT
		   void operator =(const Garage_T& source);

		  // FINAL PROJECT FEATURE
		  friend ostream& operator <<(ostream& outs, const Garage_T& the_object);
		  //Overloads the << operator for output content of type Garage_T.
		  //Precondition: If outs is a file output stream, then outs has already been
		  //connected to a file.


	private:
		int static MAX_CAPACITY;

		// Generic sort predicate as a member function, same logic as in the non-member example
		// Must be a static method, as the generic sort function will not have a Bag's object instance
		static bool sortVehiclePredicate_member(VehiclePtr, VehiclePtr);

		// FINAL PROJECT FEATURE - STL container
		// A vector container is used to hold pointers to vehicles.  This will practice polymorphism
		vector<VehiclePtr> vehicles;  

		// FINAL PROJECT FEATURE - Iterator
		// We need an iterator on the vector, in order to use STL functions, such as sort.  
		// An iterator is a generic concept to let us visit the elements of the container 
		vector<VehiclePtr>::iterator where;
			
	};

} // namespace csci2312
