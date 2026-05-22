import { Component, inject, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { SidebarComponent } from '../sidebar/sidebar.component';

@Component({
  selector: 'app-header',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './header.component.html',
  styleUrls: ['./header.component.scss']
})
export class HeaderComponent {
  notificationCount = signal(3);
  showNotifications = signal(false);
  showUserMenu = signal(false);
  currentUser = signal({ name: 'John Doe', role: 'Admin' });

  sidebarComponent = inject(SidebarComponent, { optional: true });

  toggleNotifications(): void {
    this.showNotifications.update(val => !val);
    this.showUserMenu.set(false);
  }

  toggleUserMenu(): void {
    this.showUserMenu.update(val => !val);
    this.showNotifications.set(false);
  }

  toggleMobileSidebar(): void {
    this.sidebarComponent?.toggleMobileSidebar();
  }

  logout(): void {
    console.log('Logout clicked');
    this.showUserMenu.set(false);
  }
}
