import { Router } from 'express';
import { getMenuItems, getMenuItemById, getMenuItemByName, createMenuItem, updateMenuItem, deleteMenuItem, toggleAvailability } from '../controllers/menuController';
import { authenticate, authorize } from '../middleware/auth';

const router = Router();

router.get('/', getMenuItems);
router.get('/:id', getMenuItemById);
router.get('/by-name/:name', getMenuItemByName);
router.post('/', authenticate, authorize('VENDOR', 'ADMIN'), createMenuItem);
router.put('/:id', authenticate, authorize('VENDOR', 'ADMIN'), updateMenuItem);
router.delete('/:id', authenticate, authorize('VENDOR', 'ADMIN'), deleteMenuItem);
router.patch('/:id/toggle-availability', authenticate, authorize('VENDOR', 'ADMIN'), toggleAvailability);

export default router;
