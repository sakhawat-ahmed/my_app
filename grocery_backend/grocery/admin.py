from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from .models import User, Category, Product

@admin.register(User)
class CustomUserAdmin(UserAdmin):
    list_display = ('username', 'email', 'user_type', 'is_verified', 'is_staff')
    list_filter = ('user_type', 'is_verified', 'is_staff')
    fieldsets = UserAdmin.fieldsets + (
        ('Additional Info', {
            'fields': ('user_type', 'phone', 'profile_picture', 'date_of_birth',
                      'loyalty_points', 'store_name', 'store_description', 
                      'is_verified', 'vehicle_type', 'license_number')
        }),
    )

@admin.register(Category)
class CategoryAdmin(admin.ModelAdmin):
    list_display = ('name', 'is_active', 'created_at')
    list_filter = ('is_active',)
    search_fields = ('name',)

@admin.register(Product)
class ProductAdmin(admin.ModelAdmin):
    list_display = ('name', 'category', 'vendor', 'price', 'stock_quantity', 'is_available')
    list_filter = ('category', 'is_available', 'is_featured')
    search_fields = ('name', 'sku')
    readonly_fields = ('sku',)

# We'll add other models to admin later as we create them