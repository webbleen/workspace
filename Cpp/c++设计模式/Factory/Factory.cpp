#include "Factory.h"

#include <iostream>
#include "Product.h"

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
