from django.core.management.base import BaseCommand
from grocery.models import Category, Product, User
from django.contrib.auth.hashers import make_password
from decimal import Decimal

class Command(BaseCommand):
    help = 'Populate sample data for grocery app'
    
    def handle(self, *args, **options):
        self.stdout.write('Populating sample data...')
        
        # Create a vendor user
        vendor, created = User.objects.get_or_create(
            username='freshmart',
            defaults={
                'email': 'vendor@freshmart.com',
                'user_type': 'vendor',
                'store_name': 'Fresh Mart Supermarket',
                'store_description': 'Your one-stop shop for fresh groceries',
                'is_verified': True,
                'password': make_password('vendor123')
            }
        )
        
        if created:
            self.stdout.write(f'Created vendor: {vendor.store_name}')
        
        # Create sample categories
        categories_data = [
            {'name': 'Fruits & Vegetables', 'description': 'Fresh fruits and vegetables'},
            {'name': 'Dairy & Eggs', 'description': 'Milk, cheese, eggs and more'},
            {'name': 'Bakery', 'description': 'Bread, cakes, and baked goods'},
            {'name': 'Beverages', 'description': 'Soft drinks, juices, and more'},
        ]
        
        categories = {}
        for cat_data in categories_data:
            category, created = Category.objects.get_or_create(
                name=cat_data['name'],
                defaults=cat_data
            )
            categories[cat_data['name']] = category
            if created:
                self.stdout.write(f'Created category: {category.name}')
        
        # Create sample products
        products_data = [
            {
                'name': 'Fresh Apples', 
                'description': 'Sweet and crunchy red apples',
                'category': categories['Fruits & Vegetables'],
                'vendor': vendor,
                'price': Decimal('120.00'),
                'compare_price': Decimal('150.00'),
                'unit': 'kg',
                'unit_size': '1',
                'stock_quantity': 50,
                'is_featured': True,
                'is_organic': True
            },
            {
                'name': 'Bananas', 
                'description': 'Fresh yellow bananas',
                'category': categories['Fruits & Vegetables'],
                'vendor': vendor,
                'price': Decimal('60.00'),
                'unit': 'kg',
                'unit_size': '1',
                'stock_quantity': 30,
                'is_featured': True
            },
            {
                'name': 'Fresh Milk', 
                'description': 'Pure cow milk',
                'category': categories['Dairy & Eggs'],
                'vendor': vendor,
                'price': Decimal('60.00'),
                'unit': 'pack',
                'unit_size': '1',
                'stock_quantity': 20,
                'is_featured': True
            },
            {
                'name': 'Whole Wheat Bread', 
                'description': 'Fresh whole wheat bread',
                'category': categories['Bakery'],
                'vendor': vendor,
                'price': Decimal('35.00'),
                'unit': 'pack',
                'unit_size': '1',
                'stock_quantity': 15,
                'is_featured': True
            },
        ]
        
        for product_data in products_data:
            product, created = Product.objects.get_or_create(
                name=product_data['name'],
                vendor=product_data['vendor'],
                defaults=product_data
            )
            if created:
                self.stdout.write(f'Created product: {product.name} - ₹{product.price}')
        
        self.stdout.write(
            self.style.SUCCESS('Successfully populated sample data!')
        )