package com.DigitalBazaar.model;

public class CartItem {
    private int id;          // orders.id
    private int userId;
    private int productId;
    private String productName;
    private double price;
    private int quantity;
    private double totalPrice;
    private String image;
    private String category;

    public int getId()                   { return id; }
    public void setId(int id)            { this.id = id; }

    public int getUserId()               { return userId; }
    public void setUserId(int userId)    { this.userId = userId; }

    public int getProductId()            { return productId; }
    public void setProductId(int pid)    { this.productId = pid; }

    public String getProductName()       { return productName; }
    public void setProductName(String n) { this.productName = n; }

    public double getPrice()             { return price; }
    public void setPrice(double price)   { this.price = price; }

    public int getQuantity()             { return quantity; }
    public void setQuantity(int qty)     { this.quantity = qty; }

    public double getTotalPrice()              { return totalPrice; }
    public void setTotalPrice(double tp)       { this.totalPrice = tp; }

    public String getImage()             { return image; }
    public void setImage(String image)   { this.image = image; }

    public String getCategory()          { return category; }
    public void setCategory(String c)    { this.category = c; }
}
