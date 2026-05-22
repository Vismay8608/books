import { Component, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink, RouterLinkActive } from '@angular/router';

interface MenuItem {
  label: string;
  icon: string;
  route?: string;
  children?: MenuItem[];
}

@Component({
  selector: 'app-sidebar',
  standalone: true,
  imports: [CommonModule, RouterLink, RouterLinkActive],
  templateUrl: './sidebar.component.html',
  styleUrls: ['./sidebar.component.scss']
})
export class SidebarComponent {
  isMobileOpen = signal(false);

  menuItems: MenuItem[] = [
    {
      label: 'Dashboard',
      icon: 'fas fa-gauge-high',
      route: '/dashboard'
    },
    {
      label: 'Books',
      icon: 'fas fa-book',
      children: [
        { label: 'All Books', icon: 'fas fa-list', route: '/books' },
        { label: 'Add Book', icon: 'fas fa-plus', route: '/books/add' },
        { label: 'Categories', icon: 'fas fa-tag', route: '/books/categories' }
      ]
    },
    {
      label: 'Users',
      icon: 'fas fa-users',
      route: '/users'
    },
    {
      label: 'Reports',
      icon: 'fas fa-chart-bar',
      children: [
        { label: 'Sales', icon: 'fas fa-arrow-trend-up', route: '/reports/sales' },
        { label: 'Analytics', icon: 'fas fa-chart-line', route: '/reports/analytics' }
      ]
    },
    {
      label: 'Settings',
      icon: 'fas fa-gear',
      route: '/settings'
    }
  ];

  expandedItems = signal<{ [key: string]: boolean }>({
    Books: false,
    Reports: false
  });

  toggleSubmenu(label: string): void {
    const current = this.expandedItems();
    this.expandedItems.set({
      ...current,
      [label]: !current[label]
    });
  }

  toggleMobileSidebar(): void {
    this.isMobileOpen.update(value => !value);
  }

  closeMobileSidebar(): void {
    this.isMobileOpen.set(false);
  }
}
