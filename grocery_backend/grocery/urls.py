from django.urls import path, include
from rest_framework.routers import DefaultRouter
from . import views

router = DefaultRouter()
router.register(r'categories', views.CategoryViewSet)
router.register(r'products', views.ProductViewSet)
router.register(r'cart', views.CartViewSet, basename='cart')
router.register(r'auth', views.AuthViewSet, basename='auth')

urlpatterns = [
    path('', include(router.urls)),
    path('health/', views.health_check, name='health-check'),
    path('home/', views.HomeAPIView.as_view(), name='home'),
    path('auth/profile/update/', views.update_user_profile, name='update-profile'),
    path('auth/change-password/', views.change_password, name='change-password'),
]