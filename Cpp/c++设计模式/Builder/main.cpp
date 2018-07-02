#include "Product.h"
#include "Director.h"
#include "ConcreteBuilder.h"

int main()
{
	Director* d = new Director(new ConcreteBuilder());
	d->Construct();

	return 0;
}