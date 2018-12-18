import datetime

# from cfginfo.models import 

from django.shortcuts import render, get_object_or_404
from django.http import HttpResponse, HttpResponseRedirect, HttpResponsePermanentRedirect, Http404, StreamingHttpResponse
from django.urls import reverse
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required

def user_login(request):
    if not request.method == 'POST':
        return render(request, 'app/registration/login.html', {'next': request.GET.get('next')})

    username = request.POST['username']
    password = request.POST['password']
    user = authenticate(username=username, password=password)

    if not user:
        return HttpResponse("invalid user: %s" % username)

    if not user.is_active:
        return HttpResponse("User %s not active" % username)

    login(request, user)

    if request.GET.get('next'):
        return HttpResponseRedirect(request.GET.get('next'))

    return HttpResponseRedirect(reverse('index'))

@login_required()
def dashboard(request):
    return render(request, 'app/sample.html')

@login_required
def user_logout(request):
    logout(request)
    return HttpResponseRedirect('/')
