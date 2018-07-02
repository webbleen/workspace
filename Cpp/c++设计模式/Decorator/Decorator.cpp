#include "Decorator.h"

#include <iostream>
using namespace std;

Component::Component()
{

}

Component::~Component()
{

}

void Component::Operation()
{
}

ConcreteComponent::ConcreteComponent()
{
}

ConcreteComponent::~ConcreteComponent()
{
}

void ConcreteComponent::Operation()
{
	cout << "ConcreteComponent::Operation" << endl;
}


Decorator::Decorator(Component * com)
{
	_com = com;
}

Decorator::~Decorator()
{
}

void Decorator::Operation()
{
}

ConreteDecorator::ConreteDecorator(Component * com) : Decorator(com)
{

}

ConreteDecorator::~ConreteDecorator()
{

}

void ConreteDecorator::Operation()
{
	_com->Operation();
	this->AddedBehavior();
}

void ConreteDecorator::AddedBehavior()
{
	cout << "ConreteDecorator::AddedBehavior" << endl;
}
