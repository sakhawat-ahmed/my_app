from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from django.http import JsonResponse

def root_view(request):
    return JsonResponse({
        'success': True,
        'message': 'Grocery Backend API',
        'endpoints': {
            'admin': '/admin/',
            'api_root': '/api/',
            'api_health': '/api/health/',
            'api_home': '/api/home/',
            'api_register': '/api/auth/register/',
            'api_login': '/api/auth/login/',
        }
    })

urlpatterns = [
    path('', root_view, name='root'),
    path('admin/', admin.site.urls),
    path('api/', include('grocery.urls')),  
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)