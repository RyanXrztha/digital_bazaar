package com.DigitalBazaar.model;

public class Product {
	private int id;
    private String name;
    private String category;
    private double price;
    private int stock;
    private String image;       // filename only, e.g. "p1.jpg"
    private boolean featured;

    // -------- GETTERS & SETTERS --------

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

    public boolean isFeatured() { return featured; }
    public void setFeatured(boolean featured) { this.featured = featured; }
}
