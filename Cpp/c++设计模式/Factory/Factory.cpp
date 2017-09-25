#include "Factory.h"

#include <iostream>

using namespace std;

Factory::Factory()
{

}

Factory::~Factory()
{

}

ConcreteFactory::ConcreteFactory()
{
    cout << "ConcreteFactory....." << endl; 
}

ConcreteFactory::~ConcreteFactory() 
{

}

Product* ConcreteFactory::CreateProduct()
{
    return new ContreteProduct();
}
