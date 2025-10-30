from rest_framework import serializers
from django.contrib.auth import authenticate
from .models import Category, Product, User

class UserRegistrationSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)
    password2 = serializers.CharField(write_only=True)
    
    class Meta:
        model = User
        fields = ('username', 'email', 'password', 'password2', 'user_type', 'phone')
    
    def validate(self, attrs):
        if attrs['password'] != attrs['password2']:
            raise serializers.ValidationError("Passwords don't match")
        return attrs
    
    def create(self, validated_data):
        validated_data.pop('password2')
        user = User.objects.create_user(**validated_data)
        return user

class UserProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ('id', 'username', 'email', 'first_name', 'last_name', 
                 'user_type', 'phone', 'profile_picture', 'date_of_birth',
                 'loyalty_points', 'store_name', 'store_description')
        
    def update(self, instance, validated_data):
        # Handle partial updates
        for attr, value in validated_data.items():
            setattr(instance, attr, value)
        instance.save()
        return instance

class CategorySerializer(serializers.ModelSerializer):
    product_count = serializers.SerializerMethodField()
    
    class Meta:
        model = Category
        fields = '__all__'
    
    def get_product_count(self, obj):
        return obj.products.filter(is_available=True).count()

class ProductSerializer(serializers.ModelSerializer):
    category_name = serializers.CharField(source='category.name', read_only=True)
    vendor_name = serializers.CharField(source='vendor.store_name', read_only=True)
    
    class Meta:
        model = Product
        fields = '__all__'