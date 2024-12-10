import { useEffect, useState, } from "react";
import { useDispatch } from "react-redux";
import { useNavigate, useLocation } from "react-router-dom";

import { List, Menu, MenuItem, MenuList, ListItemText, ListItemIcon } from '@mui/material';
import MenuIcon from '@mui/icons-material/Menu';
import InfoOutlinedIcon from '@mui/icons-material/InfoOutlined';
import AddCircleOutlineOutlinedIcon from '@mui/icons-material/AddCircleOutlineOutlined';
import ListOutlinedIcon from '@mui/icons-material/ListOutlined';
import ContactSupportOutlinedIcon from '@mui/icons-material/ContactSupportOutlined';
import MapOutlinedIcon from '@mui/icons-material/MapOutlined';
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

    useEffect(() => {
        console.log('********Location*********', location);
    }, []);

    return (
        <>
            <IconButton onClick={handleMenuOpen} sx={{ color: '#080808'}}>
                <MenuIcon />
            </IconButton>
            <Menu
                anchorEl={anchorEl}
                anchorOrigin={{
                  vertical: "top",
                  horizontal: "left",
                }}
                open={Boolean(anchorEl)}
                onClose={handleMenuClose}
            >
                <MenuItem onClick={handleAboutScreen}>
                <ListItemIcon><InfoOutlinedIcon/></ListItemIcon>
                    <ListItemText>About</ListItemText>
                </MenuItem>
                <MenuItem onClick={handleAddBathrom}>
                        <ListItemIcon><AddCircleOutlineOutlinedIcon/></ListItemIcon>
                    <ListItemText>Add a bathroom</ListItemText>
                </MenuItem>

                {location.pathname === '/listview' &&
                    <MenuItem onClick={handleMapView}>
                        <ListItemIcon><MapOutlinedIcon/></ListItemIcon>
                        <ListItemText>Map View</ListItemText>
                    </MenuItem>
                }
                {location.pathname !== '/listview' &&
                    <MenuItem onClick={handleListView}>
                        <ListItemIcon><ListOutlinedIcon/></ListItemIcon>
                        <ListItemText>List View</ListItemText>
                        </MenuItem>
                }

                <MenuItem onClick={handleContact}>
                <ListItemIcon><ContactSupportOutlinedIcon/></ListItemIcon>
                    <ListItemText>Contact Us</ListItemText>
                </MenuItem>

            </Menu>
        </>

    );
}