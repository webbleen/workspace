#pragma once

class Component
{
public:
	virtual ~Component();
	virtual void Operation();

protected:
	Component();

private:

};

class ConcreteComponent : public Component
{
public:
	ConcreteComponent();
	~ConcreteComponent();

	virtual void Operation() override;

private:

};


class Decorator : public Component
{
public:
	Decorator(Component* com);
	virtual ~Decorator();

	void Operation();

protected:
	Component * _com;
};

class ConreteDecorator : public Decorator
{
public:
	ConreteDecorator(Component* com);
	~ConreteDecorator();

	void Operation();
	void AddedBehavior();
private:

};
