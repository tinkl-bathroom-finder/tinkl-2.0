import { useState } from "react";
import { useDispatch } from "react-redux";
import { useNavigate, useLocation } from "react-router-dom";

import { Menu, MenuItem } from '@mui/material';
import MenuIcon from '@mui/icons-material/Menu';
import { IconButton } from "@mui/material";

//Redux Actions
import { toggleAboutScreen } from "../redux/reducers/tinklOptionsReducer";

export const AppHamburgerMenu: React.FC = () => {

    const [anchorEl, setAnchorEl] = useState<null | HTMLElement>(null);
    const dispatch = useDispatch();
    const navigate = useNavigate();
    const location = useLocation();

    const handleMenuOpen = (event: React.MouseEvent<HTMLElement>) => {
        setAnchorEl(event.currentTarget);
    }

    const handleMenuClose = () => {
        setAnchorEl(null);
    }

    const handleAboutScreen = () => {
        setAnchorEl(null);
        dispatch(toggleAboutScreen());
    }

    const handleListView = () => {
        setAnchorEl(null);
        navigate("/listview");
    }

    const handleAddBathrom = () => {
        setAnchorEl(null);
        navigate("/addbathroom");
    }

    const handleContact = () => {
        setAnchorEl(null);
        navigate("/contact");
    }

    const handleMapView = () => {
        setAnchorEl(null);
        navigate('/');
    }

    // useEffect(() => {
    //     console.log('********Location*********', location);
    // }, []);

    return (
        <>
            <IconButton onClick={handleMenuOpen} sx={{ color: '#080808', pl: '20px' }}>
                <MenuIcon />
            </IconButton>
            <Menu
                anchorEl={anchorEl}
                open={Boolean(anchorEl)}
                onClose={handleMenuClose}
            >
                <MenuItem onClick={handleAboutScreen}>About</MenuItem>
                <MenuItem onClick={handleAddBathrom}>Add</MenuItem>

                {location.pathname === '/listview' &&
                    <MenuItem onClick={handleMapView}>Map View</MenuItem>
                }
                {location.pathname !== '/listview' &&
                    <MenuItem onClick={handleListView}>List View</MenuItem>
                }

                <MenuItem onClick={handleContact}>Contact Us</MenuItem>

            </Menu>
        </>

    );
}