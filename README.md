# Angular Dashboard Template

A modern, responsive dashboard template built with **Angular 18** and **Bootstrap 5**, inspired by TailAdmin design.

## Features

✅ **Responsive Sidebar Navigation** - Fixed sidebar with collapsible menu items  
✅ **Sticky Header** - Top navigation with notifications and user profile  
✅ **Dashboard Page** - Stat cards, charts placeholder, and recent items table  
✅ **Bootstrap 5 Integration** - All Bootstrap utilities and components  
✅ **Custom SCSS Theme** - Minimal custom styling for enhanced components  
✅ **Modern Design** - Clean, professional UI inspired by TailAdmin  
✅ **Mobile Responsive** - Works perfectly on all screen sizes  
✅ **Standalone Components** - Latest Angular 18 standalone components  

## Project Structure

```
src/
├── app/
│   ├── components/
│   │   ├── sidebar/           # Main navigation sidebar
│   │   └── header/            # Top header with notifications
│   ├── pages/
│   │   └── dashboard/         # Main dashboard page
│   ├── app.component.*        # Root component
│   └── app.routes.ts          # Routing configuration
├── styles.scss                # Global theme and custom classes
└── index.html                 # HTML entry point
```

## Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd angular-dashboard
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Start development server**
   ```bash
   npm start
   ```

4. **Open browser**
   ```
   http://localhost:4200
   ```

## Custom Classes Reference

### Sidebar
- `.sidebar` - Main sidebar container
- `.sidebar-brand` - Brand/logo section
- `.sidebar-menu` - Menu list
- `.sidebar-link` - Navigation links
- `.sidebar-submenu` - Nested menu items

### Header
- `.header` - Top navigation bar
- `.header-wrapper` - Header content wrapper
- `.hamburger` - Mobile menu toggle
- `.notification-icon` - Notification bell
- `.user-profile` - User profile section

### Cards
- `.card` - Base card component
- `.card-stat` - Statistic card with icon
- `.card-header`, `.card-body`, `.card-footer` - Card sections

### Buttons
- `.btn-soft-primary` - Soft primary button variant
- `.btn`, `.btn-sm`, `.btn-lg` - Bootstrap button classes

### Utilities
- `.shadow-xs`, `.shadow-md`, `.shadow-lg`, `.shadow-xl` - Custom shadows
- `.transition-all`, `.transition-colors` - Smooth transitions
- `.text-primary-light`, `.bg-primary-light` - Custom color utilities

## Color Theme

- **Primary**: `#3c50e0` (Blue)
- **Secondary**: `#637381` (Gray)
- **Success**: `#10b981` (Green)
- **Danger**: `#ef4444` (Red)
- **Warning**: `#f59e0b` (Amber)
- **Info**: `#06b6d4` (Cyan)

## Bootstrap Components Used

- Grid System (container, row, col)
- Typography (headings, paragraphs, links)
- Tables (`.table`, `.table-hover`)
- Forms (`.form-control`, `.form-label`)
- Badges (`.badge`, `.badge-primary`, etc.)
- Alerts (`.alert`, `.alert-success`, etc.)
- Buttons (`.btn`, `.btn-primary`, `.btn-outline-*`)
- Dropdowns (`.dropdown-menu`, `.dropdown-item`)
- Modals (`.modal`, `.modal-content`)
- Progress bars (`.progress`, `.progress-bar`)
- Pagination (`.pagination`, `.page-link`)

## Development

### Add New Components

```bash
ng generate component components/my-component
```

### Add New Pages

```bash
ng generate component pages/my-page
```

Then add route in `app.routes.ts`:

```typescript
{ path: 'my-page', component: MyPageComponent }
```

### Build for Production

```bash
npm run build
```

## Browser Support

- Chrome (latest)
- Firefox (latest)
- Safari (latest)
- Edge (latest)

## License

MIT

## Support

For issues and questions, please open an issue on GitHub.
