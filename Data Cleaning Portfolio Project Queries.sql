/*

Cleaning Data in SQL Queries

*/


Select *
From nashvile_data

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

ALTER TABLE nashvile_data
ALTER COLUMN SaleDate TYPE Date

 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From nashvile_data
--Where PropertyAddress is null
order by ParcelID


alter table nashvile_data
rename "uniqueid " to uniqueid


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
From nashvile_data a
JOIN nashvile_data b
	on a.ParcelID = b.ParcelID
	AND a.uniqueid <> b.uniqueid
Where a.PropertyAddress is null
and b.PropertyAddress is not null


Update nashvile_data
SET PropertyAddress = coalesce(a.PropertyAddress,b.PropertyAddress)
From nashvile_data a
JOIN nashvile_data b
	on a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
Where a.PropertyAddress is null
and b.PropertyAddress is not null




--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From nashvile_data
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, position(',' in PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, position(',' in PropertyAddress) + 1 , length(PropertyAddress)) as City

From nashvile_data


ALTER TABLE nashvile_data
Add PropertySplitAddress varchar(255);

Update nashvile_data
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, position(',' in PropertyAddress) -1 )


ALTER TABLE nashvile_data
Add PropertySplitCity varchar(255);

Update nashvile_data
SET PropertySplitCity = SUBSTRING(PropertyAddress, position(',' in PropertyAddress) + 1 , length(PropertyAddress))


Select *
From nashvile_data


Select OwnerAddress
From nashvile_data


Select
regexp_replace(OwnerAddress, '(.+)\,.+\,.+', '\1'),
regexp_replace(OwnerAddress, '.+\,(.+)\,.+', '\1'),
regexp_replace(OwnerAddress, '.+\,.+\,(.+)', '\1')
From nashvile_data
where Owneraddress is not null


ALTER TABLE nashvile_data
Add OwnerSplitAddress varchar(255),
Add OwnerSplitCity varchar(255),
Add OwnerSplitState varchar(255);

Update nashvile_data
SET OwnerSplitAddress = regexp_replace(OwnerAddress, '(.+)\,.+\,.+', '\1'),
OwnerSplitCity = regexp_replace(OwnerAddress, '.+\,(.+)\,.+', '\1'),
OwnerSplitState = regexp_replace(OwnerAddress, '.+\,.+\,(.+)', '\1')



Select *
From nashvile_data




--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From nashvile_data
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From nashvile_data


Update nashvile_data
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END






-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH t1 AS
    (SELECT DISTINCT ON (ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference) * FROM nashvile_data)
DELETE FROM nashvile_data WHERE nashvile_data.uniqueid NOT IN (SELECT uniqueid FROM t1);



Select *
From nashvile_data




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



ALTER TABLE nashvile_data
DROP COLUMN taxdistrict

select * from nashvile_data














-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------


















