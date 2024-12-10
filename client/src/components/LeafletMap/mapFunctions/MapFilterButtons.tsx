import { useDispatch, useSelector } from 'react-redux'

import { TinklRootState } from '../../../redux/types/TinklRootState.ts';

import {
    toggleOpen,
    togglePublic,
    toggleAccessible,
    toggleChangingTable,
} from '../../../redux/reducers/bathroomFiltersReducer.ts'

import {
    AccessibleForwardOutlined,
    BabyChangingStationOutlined,
    Public,
} from "@mui/icons-material";

import { Button } from '@mui/material';



export const FilterOpenButton: React.FC = () => {
    const dispatch = useDispatch()
    const filters = useSelector((state: TinklRootState) => state.filters);
    return (
        <Button
            onClick={() => dispatch(toggleOpen())}
            style={{
                position: 'absolute',
                top: '10px',
                right: '10px',
                height: '32px',
                width: '101px',
                border: '2px solid grey',
                borderRadius: '5px',
                backgroundColor: !filters.open ? 'white' : 'gray',
                zIndex: 1000,
                textTransform: 'lowercase',
                fontWeight: 'bold'
            }}
        >
            open now
        </Button>
    )
};

export const FilterAccessibleButton: React.FC = () => {
    const dispatch = useDispatch()
    const filters = useSelector((state: TinklRootState) => state.filters);
    return (
        <Button
            onClick={() => dispatch(toggleAccessible())}
            style={{
                position: 'absolute',
                top: '41px',
                right: '76px',
                height: '32px',
                minWidth: '0px',
                width: '35px',
                padding: '0',
                border: '2px solid grey',
                borderRadius: '5px',
                backgroundColor: !filters.accessible ? 'white' : 'gray',
                zIndex: 1000,
            }}
        >
            <AccessibleForwardOutlined />
        </Button>
    )
};

export const FilterChangingButton: React.FC = () => {
    const dispatch = useDispatch()
    const filters = useSelector((state: TinklRootState) => state.filters);
    return (
        <Button
            onClick={() => dispatch(toggleChangingTable())}
            style={{
                position: 'absolute',
                top: '41px',
                right: '43px',
                height: '32px',
                minWidth: '0px',
                width: '35px',
                padding: '0',
                border: '2px solid grey',
                borderRadius: '5px',
                backgroundColor: !filters.changingTable ? 'white' : 'gray',
                zIndex: 1000,
            }}
        >
            <BabyChangingStationOutlined />
        </Button>
    )
};

export const FilterPublicButton: React.FC = () => {
    const dispatch = useDispatch()
    const filters = useSelector((state: TinklRootState) => state.filters);
    return (
        <Button
            onClick={() => dispatch(togglePublic())}
            style={{
                position: 'absolute',
                top: '41px',
                right: '10px',
                height: '32px',
                minWidth: '0px',
                width: '35px',
                padding: '0',
                border: '2px solid grey',
                borderRadius: '5px',
                backgroundColor: !filters.public ? 'white' : 'gray',
                zIndex: 1000,
            }}
        >
            <Public />
        </Button>
    )
};
