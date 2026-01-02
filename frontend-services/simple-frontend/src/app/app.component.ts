import { Component, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterOutlet } from '@angular/router';
import { HttpClient } from '@angular/common/http';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule, RouterOutlet, FormsModule],
  template: `
    <div style="max-width: 800px; margin: 0 auto; padding: 20px; font-family: Arial, sans-serif;">
      <header style="text-align: center; margin-bottom: 30px;">
        <h1 style="color: #8B5CF6;">🚀 RevHub</h1>
        <p>Simple Social Media Platform</p>
      </header>

      <div *ngIf="!isLoggedIn" style="max-width: 400px; margin: 0 auto;">
        <div style="background: #f9f9f9; padding: 20px; border-radius: 8px; margin-bottom: 20px;">
          <h3>Login</h3>
          <input [(ngModel)]="loginData.username" placeholder="Username" 
                 style="width: 100%; padding: 10px; margin: 5px 0; border: 1px solid #ddd; border-radius: 4px;">
          <input [(ngModel)]="loginData.password" type="password" placeholder="Password"
                 style="width: 100%; padding: 10px; margin: 5px 0; border: 1px solid #ddd; border-radius: 4px;">
          <button (click)="login()" style="width: 100%; padding: 10px; background: #8B5CF6; color: white; border: none; border-radius: 4px; cursor: pointer;">
            Login
          </button>
        </div>

        <div style="background: #f9f9f9; padding: 20px; border-radius: 8px;">
          <h3>Register</h3>
          <input [(ngModel)]="registerData.username" placeholder="Username"
                 style="width: 100%; padding: 10px; margin: 5px 0; border: 1px solid #ddd; border-radius: 4px;">
          <input [(ngModel)]="registerData.email" placeholder="Email"
                 style="width: 100%; padding: 10px; margin: 5px 0; border: 1px solid #ddd; border-radius: 4px;">
          <input [(ngModel)]="registerData.password" type="password" placeholder="Password"
                 style="width: 100%; padding: 10px; margin: 5px 0; border: 1px solid #ddd; border-radius: 4px;">
          <button (click)="register()" style="width: 100%; padding: 10px; background: #10B981; color: white; border: none; border-radius: 4px; cursor: pointer;">
            Register
          </button>
        </div>
      </div>

      <div *ngIf="isLoggedIn">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
          <h2>Welcome, {{currentUser}}!</h2>
          <button (click)="logout()" style="padding: 8px 16px; background: #EF4444; color: white; border: none; border-radius: 4px; cursor: pointer;">
            Logout
          </button>
        </div>

        <div style="background: #f9f9f9; padding: 20px; border-radius: 8px; margin-bottom: 20px;">
          <h3>Create Post</h3>
          <textarea [(ngModel)]="newPost" placeholder="What's on your mind?"
                    style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; min-height: 80px; resize: vertical;"></textarea>
          <button (click)="createPost()" style="margin-top: 10px; padding: 10px 20px; background: #8B5CF6; color: white; border: none; border-radius: 4px; cursor: pointer;">
            Post
          </button>
        </div>

        <div>
          <h3>Feed</h3>
          <div *ngFor="let post of posts" style="background: white; border: 1px solid #ddd; border-radius: 8px; padding: 15px; margin-bottom: 15px;">
            <div style="font-weight: bold; color: #8B5CF6; margin-bottom: 5px;">@{{post.author}}</div>
            <div>{{post.content}}</div>
            <div style="color: #666; font-size: 12px; margin-top: 10px;">{{post.timestamp || 'Just now'}}</div>
          </div>
        </div>
      </div>

      <div *ngIf="message" style="position: fixed; top: 20px; right: 20px; background: #10B981; color: white; padding: 10px 20px; border-radius: 4px;">
        {{message}}
      </div>
    </div>
  `
})
export class AppComponent {
  private http = inject(HttpClient);
  
  isLoggedIn = false;
  currentUser = '';
  message = '';
  
  loginData = { username: '', password: '' };
  registerData = { username: '', email: '', password: '' };
  newPost = '';
  posts: any[] = [];

  ngOnInit() {
    this.loadPosts();
  }

  login() {
    if (!this.loginData.username || !this.loginData.password) {
      this.showMessage('Please fill all fields');
      return;
    }

    this.http.post('http://localhost:8090/api/auth/login', this.loginData).subscribe({
      next: (response: any) => {
        this.isLoggedIn = true;
        this.currentUser = response.user;
        this.showMessage('Login successful!');
        this.loadPosts();
      },
      error: () => {
        this.showMessage('Login failed');
      }
    });
  }

  register() {
    if (!this.registerData.username || !this.registerData.email || !this.registerData.password) {
      this.showMessage('Please fill all fields');
      return;
    }

    this.http.post('http://localhost:8090/api/auth/register', this.registerData).subscribe({
      next: (response: any) => {
        this.showMessage('Registration successful! Please login.');
        this.registerData = { username: '', email: '', password: '' };
      },
      error: () => {
        this.showMessage('Registration failed');
      }
    });
  }

  logout() {
    this.isLoggedIn = false;
    this.currentUser = '';
    this.showMessage('Logged out successfully');
  }

  createPost() {
    if (!this.newPost.trim()) {
      this.showMessage('Please enter some content');
      return;
    }

    const post = {
      content: this.newPost,
      author: this.currentUser,
      timestamp: new Date().toLocaleString()
    };

    this.posts.unshift(post);
    this.newPost = '';
    this.showMessage('Post created!');
  }

  loadPosts() {
    this.http.get('http://localhost:8090/api/posts').subscribe({
      next: (posts: any) => {
        this.posts = posts;
      },
      error: () => {
        this.posts = [
          { content: 'Welcome to RevHub!', author: 'admin' },
          { content: 'This is a demo post', author: 'user1' }
        ];
      }
    });
  }

  showMessage(msg: string) {
    this.message = msg;
    setTimeout(() => this.message = '', 3000);
  }
}