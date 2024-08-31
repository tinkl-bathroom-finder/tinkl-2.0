import React, { useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import { Avatar, Menu, MenuItem, IconButton, Button } from "@mui/material";

//Actions
import { toggleLoginScreen, toggleUserProfile } from "../redux/reducers/tinklOptionsReducer";
import { logoutUser } from "../redux/reducers/userReducer";

//Types
import { TinklRootState } from "../redux/types/TinklRootState";

//CSS
import '../App.css';
import axios from "axios";
import { setUser } from "../redux/reducers/userReducer";

export const UserMenu: React.FC = () => {
    const api = import.meta.env.VITE_API_BASE_URL;

    const user = useSelector((state: TinklRootState) => state.user);

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
        axios.post(`${api}/user/logout`,)
            .then((response) => {
                dispatch(logoutUser());
                console.log(response.data);
                handleMenuClose();
            }).catch((error) => {
                console.error('Error logging out', error);
            })
    }

    return (
        <div className="menuContainer">
            {user.id !== 0 &&
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
                        {/* <MenuItem onClick={handleLoginClick}>Login/Register</MenuItem> */}
                        <MenuItem onClick={handleLogoutClick}>Logout</MenuItem>
                    </Menu>
                </div>
            }

            {!user.id &&
                <div id="loginButtonContainer">
                    <Button size="small" variant="contained" onClick={handleLoginClick}>Log In</Button>
                </div>
            }
        </div>
    )
}