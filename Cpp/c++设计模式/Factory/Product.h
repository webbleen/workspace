#ifndef _PRODUCT_H_
#define _PRODUCT_H_

class Product
{
public:
    virtual ~Product() = 0;

//protected:
    Product();
};

class ContreteProduct : public Product
{
public:
    ~ContreteProduct();
    ContreteProduct();
};

#endif
