#pragma once
class Product
{
public:
	Product();
	~Product();
	void ProducePart();
private:

};

class ProducePart
{
public:
	// ProducePart();
	// ~ProducePart();
	ProducePart * BuildPart();

private:

};