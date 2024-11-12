import * as React from "react";
// import Box from '@mui/material/Box';
// import Drawer from '@mui/material/Drawer';
import List from '@mui/material/List';
// import Divider from'@mui/material/Divider';
// import ListItem from '@mui/material/ListItem';
import ListItemButton from '@mui/material/ListItemButton';
import ListItemText from '@mui/material/ListItemText';
import MenuItem from '@mui/material/MenuItem';
import Menu from '@mui/material/Menu';
import { Book } from "@mui/icons-material";

const options = [
    'Find a bathroom',
    'About TINKL',
    'List View',
    'Contact us',
];
export default function HamburgerMenu() {
    const [anchorEl, setAnchorEl] = React.useState<null | HTMLElement>(null);
    const [selectedIndex, setSelectedIndex] = React.useState(1);
    const open = Boolean(anchorEl);
    const handleClickListItem = (event: React.MouseEvent<HTMLElement>) => {
        setAnchorEl(event.currentTarget);
    };

    const handleMenuItemClick = (
        event: React.MouseEvent<HTMLElement>,
        index: number
    ) => {
        setSelectedIndex(index);
        setAnchorEl(null);
    };

    const handleClose = () => {
        setAnchorEl(null);
    };

    return (
        <div>
            <List
                component="nav"
                aria-label="Navigation"
                sx={{ bgcolor: 'background.paper' }}
            >
                <ListItemButton>
                    id='lock'

                    <ListItemText>

                    </ListItemText>
                </ListItemButton>



            </List>
        </div>
    )
}