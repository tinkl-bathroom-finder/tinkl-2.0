import React, { useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import { useNavigate } from "react-router-dom";
import { Avatar, Menu, MenuItem, IconButton, Button } from "@mui/material";

//Actions
import { logoutUser } from "../redux/reducers/userReducer";

//Types
import { TinklRootState } from "../redux/types/TinklRootState";

//CSS
import '../App.css';
import axios from "axios";

export const UserMenu: React.FC = () => {
    const api = import.meta.env.VITE_API_BASE_URL;

    const user = useSelector((state: TinklRootState) => state.user);

    const [anchorEl, setAnchorEl] = useState<null | HTMLElement>(null);
    const dispatch = useDispatch();
    const navigate = useNavigate();

    const handleMenuOpen = (event: React.MouseEvent<HTMLElement>) => {
        setAnchorEl(event.currentTarget);
    }

    const handleMenuClose = () => {
        setAnchorEl(null);
    }

    const handleProfileClick = () => {
        navigate("/userProfile");
    }

    const handleLoginClick = () => {
        navigate("/login");
    }

    const handleRegisterClick = () => {
        navigate("/register");
    }

    const handleLogoutClick = () => {
        axios.post(`${api}/user/logout`,)
            .then((response) => {
                dispatch(logoutUser());
                console.log(response.data);
                handleMenuClose();
                navigate("/");
            }).catch((error) => {
                console.error('Error logging out', error);
            })
    }

    return (
        <div className="menuContainer">
            {user.id !== 0 &&
                <div id="loginButtonContainer">
                    <IconButton onClick={handleMenuOpen}
                        sx={{

                            width: 50,
                            height: 50,
                        }}
                    >
                        <Avatar alt="User Avatar"
                            aria-label="User Account Menu"
                            sx={{
                                width: 35,
                                height: 35,
                                backgroundColor: '#0F172A',
                                color: '#bc99db'
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
                    <IconButton onClick={handleMenuOpen}
                        sx={{
                            width: 50,
                            height: 50,
                        }}
                    >
                        <Avatar alt="User Avatar"
                            aria-label="User Account Menu"
                            sx={{
                                width: 35,
                                height: 35,
                                backgroundColor: '#0F172A',
                                color: '#bc99db'
                            }}
                        />
                    </IconButton>
                    <Menu
                        anchorEl={anchorEl}
                        open={Boolean(anchorEl)}
                        onClose={handleMenuClose}
                    >
                        <MenuItem onClick={handleLoginClick}>Log In/Register</MenuItem>
                    </Menu>
                </div>
            }
        </div>
    )
}