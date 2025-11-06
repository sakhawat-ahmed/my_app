from django.db import models
from django.contrib.auth.models import AbstractUser
from django.core.validators import MinValueValidator, MaxValueValidator

class User(AbstractUser):
    USER_TYPES = (
        ('customer', 'Customer'),
        ('vendor', 'Vendor'),
        ('delivery', 'Delivery Partner'),
    )
    
    user_type = models.CharField(max_length=20, choices=USER_TYPES, default='customer')
    phone = models.CharField(max_length=15, blank=True)
    profile_picture = models.ImageField(upload_to='profiles/', null=True, blank=True)
    date_of_birth = models.DateField(null=True, blank=True)
    
    # Customer specific fields
    loyalty_points = models.IntegerField(default=0)
    
    # Vendor specific fields
    store_name = models.CharField(max_length=255, blank=True)
    store_description = models.TextField(blank=True)
    is_verified = models.BooleanField(default=False)
    
    # Delivery partner specific fields
    vehicle_type = models.CharField(max_length=50, blank=True)
    license_number = models.CharField(max_length=100, blank=True)
    
    def __str__(self):
        return f"{self.username} ({self.user_type})"

class Category(models.Model):
    name = models.CharField(max_length=100)
    description = models.TextField(blank=True)
    image = models.ImageField(upload_to='categories/', null=True, blank=True)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        verbose_name_plural = "Categories"
    
    def __str__(self):
        return self.name

class Product(models.Model):
    UNIT_CHOICES = (
        ('kg', 'Kilogram'),
        ('gm', 'Gram'),
        ('lb', 'Pound'),
        ('piece', 'Piece'),
        ('pack', 'Pack'),
        ('bottle', 'Bottle'),
        ('liter', 'Liter'),
        ('ml', 'Milliliter'),
    )
    
    name = models.CharField(max_length=255)
    description = models.TextField(blank=True)
    category = models.ForeignKey(Category, on_delete=models.CASCADE, related_name='products')
    vendor = models.ForeignKey(User, on_delete=models.CASCADE, limit_choices_to={'user_type': 'vendor'})
    
    price = models.DecimalField(max_digits=10, decimal_places=2)
    compare_price = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)
    cost_price = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)
    
    unit = models.CharField(max_length=20, choices=UNIT_CHOICES, default='piece')
    unit_size = models.CharField(max_length=50, help_text="e.g., 500, 1, 2.5")
    
    stock_quantity = models.IntegerField(default=0)
    min_stock_alert = models.IntegerField(default=10)
    is_available = models.BooleanField(default=True)
    
    sku = models.CharField(max_length=100, unique=True, blank=True)
    barcode = models.CharField(max_length=100, blank=True)
    
    is_featured = models.BooleanField(default=False)
    is_organic = models.BooleanField(default=False)
    is_deal = models.BooleanField(default=False)
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    def save(self, *args, **kwargs):
        if not self.sku:
            import uuid
            self.sku = f"PROD-{uuid.uuid4().hex[:8].upper()}"
        super().save(*args, **kwargs)
    
    def __str__(self):
        return f"{self.name} - {self.vendor.store_name if self.vendor.store_name else self.vendor.username}"

class ProductImage(models.Model):
    product = models.ForeignKey(Product, on_delete=models.CASCADE, related_name='images')
    image = models.ImageField(upload_to='products/')
    is_primary = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    
    def __str__(self):
        return f"Image for {self.product.name}"

class Cart(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='cart')
    product = models.ForeignKey(Product, on_delete=models.CASCADE)
    quantity = models.PositiveIntegerField(default=1)
    added_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        unique_together = ['user', 'product']
    
    def __str__(self):
        return f"{self.quantity} x {self.product.name} - {self.user.username}"
    
    @property
    def total_price(self):
        return self.quantity * self.product.price