# Angular Admin Dashboard Theme - Bootstrap 5

A complete, production-ready admin dashboard theme built with Angular and Bootstrap 5. Features a modern blue and white theme with comprehensive UI components.

## 🎯 Features

✅ **Responsive Design** - Works seamlessly on all devices
✅ **Bootstrap 5** - Latest Bootstrap framework
✅ **Sidebar Navigation** - Collapsible sidebar with smooth animations
✅ **Header** - Profile dropdown, notifications, messages, search
✅ **Forms** - Complete form examples with all input types
✅ **Tables** - Data tables with pagination
✅ **Cards** - Stat cards and feature cards
✅ **Modals** - Modal dialog examples
✅ **Tabs** - Tab navigation with content
✅ **Mobile Optimized** - Fully responsive layout

## 📁 Project Structure

```
dashboard/
├── src/
│   ├── app/
│   │   ├── components/
│   │   │   ├── header/
│   │   │   ├── sidebar/
│   │   │   └── footer/
│   │   ├── pages/
│   │   │   ├── dashboard/
│   │   │   ├── forms/
│   │   │   ├── tables/
│   │   │   ├── cards/
│   │   │   ├── modals/
│   │   │   └── tabs/
│   │   ├── app.component.ts
│   │   └── app.routes.ts
│   ├── styles.css
│   └── main.ts
├── package.json
└── README.md
```

## 🚀 Quick Start

### 1. Install Dependencies
```bash
cd dashboard
npm install
```

### 2. Add Bootstrap CSS to angular.json
```json
"styles": [
  "node_modules/bootstrap/dist/css/bootstrap.min.css",
  "src/styles.css"
]
```

### 3. Run the Application
```bash
npm start
```

Navigate to `http://localhost:4200/`

## 📄 Available Pages

| Page | Description |
|------|-------------|
| **Dashboard** | Overview with stats cards and activity feed |
| **Forms** | Complete form examples with all input types |
| **Tables** | Data table with pagination controls |
| **Cards** | Stat cards and feature cards showcase |
| **Modals** | Basic, alert, and confirmation modal examples |
| **Tabs** | Tab navigation with different content sections |

## 🎨 Customization

### Colors
Edit CSS variables in `src/styles.css`:

```css
:root {
  --bs-primary: #0d6efd;
  --bs-success: #198754;
  --bs-danger: #dc3545;
  --bs-warning: #ffc107;
  --bs-info: #0dcaf0;
}
```

### Theme Colors
- **Primary**: Blue (#0d6efd)
- **Success**: Green (#198754)
- **Danger**: Red (#dc3545)
- **Warning**: Yellow (#ffc107)
- **Info**: Cyan (#0dcaf0)

## 📝 Form Inputs Included

✓ Text Input
✓ Email Input
✓ Password Input
✓ Number Input
✓ Telephone Input
✓ URL Input
✓ Large Input
✓ Default Input
✓ Small Input
✓ Readonly Input
✓ Disabled Input
✓ Select Dropdown
✓ Textarea
✓ Checkboxes
✓ Radio Buttons

## 🔧 Components Overview

### Header Component
- Search functionality
- Message notifications badge
- Bell notifications badge
- Profile dropdown menu
- Responsive design

### Sidebar Component
- Logo and branding
- Navigation menu items
- Active route highlighting
- Collapsible on mobile
- Smooth animations

### Footer Component
- Copyright information
- Responsive layout
- Dynamic year

## 📊 Dashboard Features

- **Stats Cards** - Display key metrics
- **Revenue Chart** - Chart placeholder
- **Recent Activity** - Activity feed
- **Responsive Layout** - Mobile optimized

## 📱 Browser Support

| Browser | Support |
|---------|---------|
| Chrome | ✅ Latest |
| Firefox | ✅ Latest |
| Safari | ✅ Latest |
| Edge | ✅ Latest |

## 🏗️ Build for Production

```bash
npm run build
```

Build artifacts will be stored in `dist/` directory.

## 📦 Dependencies

- **Angular 17** - Frontend framework
- **Bootstrap 5** - UI framework
- **Bootstrap Icons** - Icon library
- **TypeScript** - Programming language

## 🎓 Standalone Components

This project uses Angular 17 standalone components:
- No NgModule required
- Tree-shakeable
- Better code organization

## 📄 License

MIT License - Free to use in your projects

## 🤝 Support

For issues and questions, please create an issue in the repository.

---

**Version:** 1.0.0
**Built with:** Angular 17 + Bootstrap 5
**Last Updated:** 2024
