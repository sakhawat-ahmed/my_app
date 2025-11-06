from rest_framework import viewsets, status, permissions
from rest_framework.decorators import action, api_view, permission_classes
from rest_framework.response import Response
from rest_framework.views import APIView
from django.db.models import Q
from django.contrib.auth import authenticate
from rest_framework.authtoken.models import Token
from .models import Category, Product, User, Cart
from .serializers import (CategorySerializer, ProductSerializer, 
                         UserProfileSerializer, UserRegistrationSerializer,
                         SimpleProductSerializer, CartSerializer)

class AuthViewSet(viewsets.ViewSet):
    @action(detail=False, methods=['post'], permission_classes=[permissions.AllowAny])
    def register(self, request):
        try:
            # Handle different password field names for compatibility
            data = request.data.copy()
            if 'password_confirm' in data and 'password2' not in data:
                data['password2'] = data['password_confirm']
            
            serializer = UserRegistrationSerializer(data=data)
            if serializer.is_valid():
                user = serializer.save()
                token, created = Token.objects.get_or_create(user=user)
                return Response({
                    'success': True,
                    'user': UserProfileSerializer(user).data,
                    'token': token.key,
                    'message': 'User registered successfully'
                }, status=status.HTTP_201_CREATED)
            return Response({
                'success': False,
                'error': serializer.errors
            }, status=status.HTTP_400_BAD_REQUEST)
        except Exception as e:
            return Response({
                'success': False,
                'error': str(e)
            }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
    
    @action(detail=False, methods=['post'], permission_classes=[permissions.AllowAny])
    def login(self, request):
        try:
            # Accept both username and email for login
            username_or_email = request.data.get('username') or request.data.get('email')
            password = request.data.get('password')
            
            if not username_or_email or not password:
                return Response({
                    'success': False,
                    'error': 'Username/email and password are required'
                }, status=status.HTTP_400_BAD_REQUEST)
            
            # Try to authenticate by username or email
            try:
                user = User.objects.get(
                    Q(username=username_or_email) | Q(email=username_or_email)
                )
                user = authenticate(username=user.username, password=password)
            except User.DoesNotExist:
                user = None
            
            if user:
                token, created = Token.objects.get_or_create(user=user)
                return Response({
                    'success': True,
                    'user': UserProfileSerializer(user).data,
                    'token': token.key,
                    'message': 'Login successful'
                })
            return Response({
                'success': False,
                'error': 'Invalid credentials'
            }, status=status.HTTP_400_BAD_REQUEST)
        except Exception as e:
            return Response({
                'success': False,
                'error': str(e)
            }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
    
    @action(detail=False, methods=['post'], permission_classes=[permissions.IsAuthenticated])
    def logout(self, request):
        try:
            request.user.auth_token.delete()
            return Response({
                'success': True,
                'message': 'Logged out successfully'
            })
        except Exception as e:
            return Response({
                'success': False,
                'error': str(e)
            }, status=status.HTTP_400_BAD_REQUEST)

@api_view(['PUT'])
@permission_classes([permissions.IsAuthenticated])
def update_user_profile(request):
    try:
        user = request.user
        serializer = UserProfileSerializer(user, data=request.data, partial=True)
        
        if serializer.is_valid():
            serializer.save()
            return Response({
                'success': True,
                'user': UserProfileSerializer(user).data,
                'message': 'Profile updated successfully'
            })
        return Response({
            'success': False,
            'error': serializer.errors
        }, status=status.HTTP_400_BAD_REQUEST)
    except Exception as e:
        return Response({
            'success': False,
            'error': str(e)
        }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def change_password(request):
    try:
        user = request.user
        current_password = request.data.get('current_password')
        new_password = request.data.get('new_password')
        
        if not current_password or not new_password:
            return Response({
                'success': False,
                'error': 'Current password and new password are required'
            }, status=status.HTTP_400_BAD_REQUEST)
        
        if not user.check_password(current_password):
            return Response({
                'success': False,
                'error': 'Current password is incorrect'
            }, status=status.HTTP_400_BAD_REQUEST)
        
        user.set_password(new_password)
        user.save()
        
        return Response({
            'success': True,
            'message': 'Password changed successfully'
        })
    except Exception as e:
        return Response({
            'success': False,
            'error': str(e)
        }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

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
        if featured and featured.lower() == 'true':
            queryset = queryset.filter(is_featured=True)
        
        return queryset

class CartViewSet(viewsets.ModelViewSet):
    serializer_class = CartSerializer
    permission_classes = [permissions.IsAuthenticated]
    
    def get_queryset(self):
        return Cart.objects.filter(user=self.request.user)
    
    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

# Home API View
class HomeAPIView(APIView):
    permission_classes = [permissions.AllowAny]
    
    def get(self, request):
        try:
            # Featured products
            featured_products = Product.objects.filter(is_featured=True, is_available=True)[:10]
            
            # Categories with products
            categories = Category.objects.filter(is_active=True)[:8]
            
            # New arrivals (recently added products)
            new_arrivals = Product.objects.filter(is_available=True).order_by('-created_at')[:8]
            
            data = {
                'success': True,
                'featured_products': SimpleProductSerializer(featured_products, many=True).data,
                'categories': CategorySerializer(categories, many=True).data,
                'new_arrivals': SimpleProductSerializer(new_arrivals, many=True).data,
            }
            
            return Response(data)
        except Exception as e:
            return Response({
                'success': False,
                'error': str(e)
            }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

# Health check view
@api_view(['GET'])
@permission_classes([permissions.AllowAny])
def health_check(request):
    return Response({
        'success': True,
        'status': 'Backend is running!',
        'message': 'Grocery API is working properly'
    })