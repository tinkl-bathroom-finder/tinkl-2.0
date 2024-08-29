import React, { useState } from "react";
import { useDispatch } from "react-redux";
import { Avatar, Menu, MenuItem, IconButton } from "@mui/material";

//Actions
import { toggleLoginScreen, toggleUserProfile } from "../redux/reducers/tinklOptionsReducer";

export const UserMenu: React.FC = () => {
    const [anchorEl, setAncorEl] = useState<null | HTMLElement>(null);
    const dispatch = useDispatch();

    const handleMenuOpen = (event: React.MouseEvent<HTMLElement>) => {
        setAncorEl(event.currentTarget);
    }

    const handleMenuClose = () => {
        setAncorEl(null);
    }

    const handleProfileClick = () => {
        dispatch(toggleUserProfile());
        handleMenuClose();
    }

    const handleLoginClick = () => {
        dispatch(toggleLoginScreen());
        handleMenuClose();
    }

    const handleLogoutClick = () => {
        console.log('Logout clicked');
        handleMenuClose();
    }

    return (
        <div>
            <IconButton onClick={handleMenuOpen}
                sx={{

                    width: 50,
                    height: 50,
                }}
            >
                <Avatar alt="User Avatar"
                    aria-label="User Account Menu"
                    sx={{
                        width: 28,
                        height: 28,
                    }}
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