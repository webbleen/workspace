#pragma once

class AbstractProductA;
class AbstractProductB;

class AbstractFactory
{
public:
	virtual ~AbstractFactory();
	virtual AbstractProductA* CreateProductA() = 0;
	virtual AbstractProductB* CreateProductB() = 0;
	
protected:
	AbstractFactory();
};

class ConcreteFactory1 : public AbstractFactory
{
public:
	ConcreteFactory1();
	~ConcreteFactory1();

	virtual AbstractProductA* CreateProductA() override;
	virtual AbstractProductB* CreateProductB() override;

private:

};

class ConcreteFactory2 : public AbstractFactory
{
public:
	ConcreteFactory2();
	~ConcreteFactory2();

	virtual AbstractProductA* CreateProductA() override;
	virtual AbstractProductB* CreateProductB() override;

private:

};

