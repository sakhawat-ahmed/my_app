from rest_framework import viewsets, status, permissions
from rest_framework.decorators import action, api_view, permission_classes
from rest_framework.response import Response
from rest_framework.views import APIView
from django.db.models import Q
from django.contrib.auth import authenticate
from rest_framework.authtoken.models import Token
from .models import Category, Product, User
from .serializers import CategorySerializer, ProductSerializer, UserProfileSerializer, UserRegistrationSerializer

class AuthViewSet(viewsets.ViewSet):
    @action(detail=False, methods=['post'], permission_classes=[permissions.AllowAny])
    def register(self, request):
        serializer = UserRegistrationSerializer(data=request.data)
        if serializer.is_valid():
            user = serializer.save()
            token, created = Token.objects.get_or_create(user=user)
            return Response({
                'user': UserProfileSerializer(user).data,
                'token': token.key,
                'message': 'User registered successfully'
            }, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    @action(detail=False, methods=['post'], permission_classes=[permissions.AllowAny])
    def login(self, request):
        username = request.data.get('username')
        password = request.data.get('password')
        
        user = authenticate(username=username, password=password)
        if user:
            token, created = Token.objects.get_or_create(user=user)
            return Response({
                'user': UserProfileSerializer(user).data,
                'token': token.key,
                'message': 'Login successful'
            })
        return Response({'error': 'Invalid credentials'}, status=status.HTTP_400_BAD_REQUEST)

@api_view(['PUT'])
@permission_classes([permissions.IsAuthenticated])
def update_user_profile(request):
    user = request.user
    serializer = UserProfileSerializer(user, data=request.data, partial=True)
    
    if serializer.is_valid():
        serializer.save()
        return Response({
            'user': UserProfileSerializer(user).data,
            'message': 'Profile updated successfully'
        })
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class CategoryViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Category.objects.filter(is_active=True)
    serializer_class = CategorySerializer
    permission_classes = [permissions.AllowAny]

class ProductViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Product.objects.filter(is_available=True)
    serializer_class = ProductSerializer
    permission_classes = [permissions.AllowAny]
    
    def get_queryset(self):
        queryset = super().get_queryset()
        
        # Filter by category
        category = self.request.query_params.get('category')
        if category:
            queryset = queryset.filter(category_id=category)
        
        # Search
        search = self.request.query_params.get('search')
        if search:
            queryset = queryset.filter(
                Q(name__icontains=search) |
                Q(description__icontains=search)
            )
        
        # Filter by featured
        featured = self.request.query_params.get('featured')
        if featured:
            queryset = queryset.filter(is_featured=True)
        
        return queryset

# Home API View
class HomeAPIView(APIView):
    permission_classes = [permissions.AllowAny]
    
    def get(self, request):
        # Featured products
        featured_products = Product.objects.filter(is_featured=True, is_available=True)[:10]
        
        # Categories with products
        categories = Category.objects.filter(is_active=True)[:8]
        
        data = {
            'featured_products': ProductSerializer(featured_products, many=True).data,
            'categories': CategorySerializer(categories, many=True).data,
        }
        
        return Response(data)