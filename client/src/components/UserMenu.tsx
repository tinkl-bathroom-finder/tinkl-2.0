import React, { useState } from "react";
import { Avatar, Menu, MenuItem, IconButton, Icon } from "@mui/material";

export const UserMenu: React.FC = () => {
    const [anchorEl, setAncorEl] = useState<null | HTMLElement>(null);

    const handleMenuOpen = (event: React.MouseEvent<HTMLElement>) => {
        setAncorEl(event.currentTarget);
    }

    const handleMenuClose = () => {
        setAncorEl(null);
    }

    const handleProfileClick = () => {
        console.log('User profile clicked');
        handleMenuClose();
    }

    const handleLoginClick = () => {
        console.log('Login clicked');
        handleMenuClose();
    }

    const handleLogoutClick = () => {
        console.log('Logout clicked');
        handleMenuClose();
    }

    return (
        <div>
            <IconButton onClick={handleMenuOpen}>
                <Avatar alt="User Avatar"
                    aria-label="User Account Menu"
                />
            </IconButton>
            <Menu
                anchorEl={anchorEl}
                open={Boolean(anchorEl)}
                onClose={handleMenuClose}
            >
                <MenuItem onClick={handleProfileClick}>Profile</MenuItem>
                <MenuItem onClick={handleLoginClick}>Login/Register</MenuItem>
                <MenuItem onClick={handleLogoutClick}>Logout</MenuItem>
            </Menu>
        </div>
    )
}