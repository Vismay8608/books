import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';

interface StatCard {
  title: string;
  value: number | string;
  change: number;
  icon: string;
  color: string;
}

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.scss']
})
export class DashboardComponent {
  statCards: StatCard[] = [
    {
      title: 'Total Books',
      value: '1,234',
      change: 12.5,
      icon: 'fas fa-book',
      color: 'primary'
    },
    {
      title: 'Active Users',
      value: '567',
      change: 8.3,
      icon: 'fas fa-users',
      color: 'success'
    },
    {
      title: 'Total Sales',
      value: '$45,230',
      change: -2.5,
      icon: 'fas fa-dollar-sign',
      color: 'warning'
    },
    {
      title: 'Revenue',
      value: '$89,500',
      change: 15.2,
      icon: 'fas fa-chart-line',
      color: 'info'
    }
  ];

  recentBooks = [
    { id: 1, title: 'The Great Gatsby', author: 'F. Scott Fitzgerald', price: '$15.99', status: 'Available' },
    { id: 2, title: 'To Kill a Mockingbird', author: 'Harper Lee', price: '$12.99', status: 'Available' },
    { id: 3, title: '1984', author: 'George Orwell', price: '$18.99', status: 'Out of Stock' },
    { id: 4, title: 'Pride and Prejudice', author: 'Jane Austen', price: '$14.99', status: 'Available' },
    { id: 5, title: 'The Catcher in the Rye', author: 'J.D. Salinger', price: '$16.99', status: 'Available' }
  ];
}
