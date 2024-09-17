import React from 'react';
import { useDispatch, useSelector } from 'react-redux';
//Types
import { TinklRootState } from '../redux/types/TinklRootState';
import { BathroomType } from '../redux/types/BathroomType';

interface WhateverThingyProps {
    bathroom: BathroomType
}



export const WhateverThingy: React.FC<WhateverThingyProps> = ({ bathroom }) => {
    const dispatch = useDispatch();
    const bathroomData = useSelector((state: TinklRootState) => state.bathroomData);



    return (
        <>
            <p>Whatever Thingy</p>
            <p>{bathroom.name}</p>
            <p>{bathroom.latitude}</p>
        </>
    )
}